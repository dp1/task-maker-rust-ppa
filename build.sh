#!/bin/bash
# Modified from https://github.com/yuezk/publish-ppa-package/blob/main/build.sh

set -o errexit -o pipefail -o nounset

sudo apt-get update && sudo apt-get install -y devscripts debhelper distro-info-data distro-info dh-exec cargo libseccomp-dev

assert_non_empty() {
    name=$1
    value=$2
    if [[ -z "$value" ]]; then
        echo "::error::Invalid Value: $name is empty." >&2
        exit 1
    fi
}

assert_non_empty repository "$REPOSITORY"
assert_non_empty gpg_private_key "$GPG_PRIVATE_KEY"
assert_non_empty gpg_passphrase "$GPG_PASSPHRASE"
assert_non_empty pkgdir "$PKGDIR"

SERIES=$(distro-info --supported)

echo "::group::Importing GPG private key..."
GPG_KEY_ID=$(echo "$GPG_PRIVATE_KEY" | gpg --import-options show-only --import | sed -n '2s/^\s*//p')
echo $GPG_KEY_ID
echo "$GPG_PRIVATE_KEY" | gpg --batch --passphrase "$GPG_PASSPHRASE" --import
echo "::endgroup::"

cd $PKGDIR

tmpfile=`mktemp`
cp debian/changelog $tmpfile

for s in $SERIES; do
    ubuntu_version=$(distro-info --series $s -r)
    version="${ubuntu_version:0:5}"

    echo "::group::Building deb for: $version ($s)"

    sed -re "s/#VERSION_NAME/$s/" -re "s/#VERSION_NUM/$version/" $tmpfile >debian/changelog

    debuild -S -d -sa \
        -k"$GPG_KEY_ID" \
        -p"gpg --batch --passphrase "$GPG_PASSPHRASE" --pinentry-mode loopback"

    dput $REPOSITORY ../*.changes

    rm -rf ../*.{changes,build,buildinfo,deb,ddeb,dsc}
    echo "::endgroup::"
done

mv $tmpfile debian/changelog
