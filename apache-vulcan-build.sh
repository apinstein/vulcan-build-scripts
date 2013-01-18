#!/bin/sh
# This scripts builds an apache tgz file that when extracted will blow away the default apache bundled on heroku dynos.
. ./vulcan-helpers.sh

APACHE_VERSION=2.2.23
# goofy vulcan output naming convention
output_name=/tmp/httpd-2.2.tgz
_tgz=${SRC_DIR}/httpd-${APACHE_VERSION}.tgz
_src=${SRC_DIR}/httpd-${APACHE_VERSION}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://mirror.cogentco.com/pub/apache//httpd/httpd-${APACHE_VERSION}.tar.gz"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available: ${_src}." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "./configure  \
        --prefix=/app/apache \
        --with-mpm=worker \
        && make install
    " \
    -p /app/apache

echo Copying tgz to ${BUILD_DIR}
mv ${output_name} ${BUILD_DIR}/
