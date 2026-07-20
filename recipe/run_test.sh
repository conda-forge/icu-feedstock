#!/bin/bash

set -e

genrb de.txt
echo "de.res" > list.txt
pkgdata -p mybundle list.txt

pkg-config --print-errors --exact-version "$PKG_VERSION" icu-uc
$CC $CFLAGS $LDFLAGS "$RECIPE_DIR/test.c" $(pkg-config --cflags --libs --static icu-uc) -o test
./test
