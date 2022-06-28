#!/bin/sh
# To be called when checking if a new task-maker-rust release is available.
# If a new version is available, this script updates debian/changelog and
# sets the createpr output to yes

set -e

# Add a new entry to debian/changelog. For example:
# add_changelog_entry 0.5.6
add_changelog_entry() {
    tmpfile=`mktemp`
    echo "task-maker-rust ($1-1~ubuntu#VERSION_NUM) #VERSION_NAME; urgency=medium" >>$tmpfile
    echo "" >>$tmpfile
    echo "  * Update to version $1" >>$tmpfile
    echo "" >>$tmpfile
    echo " -- Dario Petrillo <dario.pk1@gmail.com>  `date -R`" >>$tmpfile
    echo "" >>$tmpfile
    cat debian/changelog >>$tmpfile
    mv $tmpfile debian/changelog
}

if [ -z ${UPSTREAM_VERSION+x} ]; then
    echo UPSTREAM_VERSION not provided
else
    CUR_RELEASE=`head debian/changelog -n 1 | sed 's/^task-maker-rust (\([0-9\.]*\).*$/\1/'`
    echo Last release in changelog is $CUR_RELEASE
    echo Last upstream release is $UPSTREAM_VERSION

    if dpkg --compare-versions "$CUR_RELEASE" lt "$UPSTREAM_VERSION"; then
        echo Updating changelog
        add_changelog_entry $UPSTREAM_VERSION
        echo "::set-output name=createpr::yes"
    else
        echo "::set-output name=createpr::no"
    fi
fi
