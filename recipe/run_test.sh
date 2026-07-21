#!/bin/bash
set -e -x

# Library checks
# https://github.com/conda-forge/icu-feedstock/issues/40
libs="libicudata libicui18n libicuio libicutest libicutu libicuuc"

for lib in $libs; do
    test ! -f "$PREFIX/lib/${lib}.a"

    if [[ "$(uname)" == "Darwin" ]]; then
        test -f "$PREFIX/lib/${lib}.${PKG_VERSION}.dylib"
    elif [[ "$(uname)" == "Linux" ]]; then
        test -f "$PREFIX/lib/${lib}.so.${PKG_VERSION}"
    fi
done

# CLI tests
genbrk --help
gencfu --help
gencnval --help
gendict --help
icuinfo --help
icu-config --help
makeconv gb-18030-2000.ucm

pkg-config --print-errors --exact-version "$PKG_VERSION" icu-uc
$CC $CFLAGS $LDFLAGS test.c $(pkg-config --cflags --libs --static icu-uc) -o test
./test
