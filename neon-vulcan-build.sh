#!/bin/sh
. ./vulcan-helpers.sh

NEON_VERSION=0.29.6
# goofy vulcan output naming convention
output_name=/tmp/neon-0.29.tgz
name=neon-${NEON_VERSION}
_tgz=${SRC_DIR}/neon-${NEON_VERSION}.tgz
_src=${SRC_DIR}/neon-${NEON_VERSION}
prefix=/app/vendor/${name}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://www.webdav.org/neon/neon-${NEON_VERSION}.tar.gz"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "./configure  \
            --prefix=${prefix} \
            --without-gssapi \
       && make install
    " \
    -p ${prefix} \
&& echo Copying binary tgz to ${BUILD_DIR} \
&& mv ${output_name} ${BUILD_DIR}/
