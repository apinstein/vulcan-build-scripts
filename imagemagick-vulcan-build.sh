#!/bin/sh
. ./vulcan-helpers.sh

IM_VERSION=6.7.4-10
# goofy vulcan output naming convention
output_name=/tmp/ImageMagick-6.7.tgz
_tgz=${SRC_DIR}/ImageMagick-${IM_VERSION}.tgz
_src=${SRC_DIR}/ImageMagick-${IM_VERSION}
name=ImageMagick-${IM_VERSION}
prefix=/app/vendor/${name}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://www.imagemagick.org/download/legacy/${name}.tar.gz"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "./configure \
            --prefix ${prefix} \
            --disable-shared \
            --with-quantum-depth=8 \
            --with-lcms \
            --with-gslib \
            --with-fontconfig   \
        && make install
    " \
    -p ${prefix} \
&& echo Extracting binaries to `pwd`/${name} \
&& mkdir -p ./${name} \
&& tar -C ./${name} -vzxf ${output_name} `tar -ztf ${output_name} | grep "^bin/"`
