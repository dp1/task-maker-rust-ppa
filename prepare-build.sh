#!/bin/sh
# To be called after debian/changelog has been updated,
# this script clones task-maker-rust and prepares it for building

set -e

# Parse the latest tmr version from the changelog
TAG=`head debian/changelog -n 1 | sed 's/^task-maker-rust (\([0-9\.]*\).*$/\1/'`
echo TAG is $TAG

mkdir build
cd build

# Prepare the directory structure
# To build the package, we need:
#  - the orig.tar.xz source tarball
#  - the debian/ folder inside the source repo
#  - the packaged dependencies

git clone --depth 1 --branch v$TAG https://github.com/edomora97/task-maker-rust
tar -cJf task-maker-rust_$TAG.orig.tar.xz task-maker-rust
cd task-maker-rust
cp -r ../../debian .

# Pack the rust dependencies in vendor.tar.xz
cargo vendor
tar -cJf debian/vendor.tar.xz vendor
rm -rf vendor
