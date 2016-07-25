#!/bin/bash

cd source
chmod +x configure install-sh

EXTRA_OPTS=""

if [ $(uname) == Darwin ]; then
  EXTRA_OPTS="--enable-rpath"
  export CC=clang
  export CXX=clang++
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
  export CXXFLAGS="$CXXFLAGS -stdlib=libc++"
fi


./configure --prefix=$PREFIX \
            --disable-samples \
            --disable-extras \
            --disable-layout \
            --disable-tests \
            --enable-static \
            "$EXTRA_OPTS"

make
make check
make install
