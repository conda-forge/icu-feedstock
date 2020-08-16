#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./source

set -e

cd source

chmod +x configure install-sh

EXTRA_OPTS=""
if [[ ${HOST} =~ .*darwin.* ]]; then
  EXTRA_OPTS="--enable-rpath"
  # TODO :: Fix this libtool cross-compilation bug
  export CC=$(dirname $(which ${CC}))/clang
  export CXX=$(dirname $(which ${CXX}))/clang++
elif [[ ${HOST} =~ .*linux.* ]]; then
  # TODO :: This is a hack until we make it so that strong run-exports in requirements/build cause those
  #         packages to be installed ino the host prefix during the build. This hack will not work for
  #         real cross-compilation!
  export LD_LIBRARY_PATH=${PREFIX}/${HOST}/lib:${LD_LIBRARY_PATH}
fi

./configure --prefix="${PREFIX}"  \
            --build=${BUILD}      \
            --host=${HOST}        \
            --disable-samples     \
            --disable-extras      \
            --disable-layout      \
            --disable-tests       \
            "${EXTRA_OPTS}"

make -j${CPU_COUNT} ${VERBOSE_CM}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
make install

rm -rf ${PREFIX}/sbin
