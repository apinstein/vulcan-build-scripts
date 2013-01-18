#!/bin/sh
# This scripts builds an apache tgz file that when extracted will blow away the default apache bundled on heroku dynos.
. ./vulcan-helpers.sh

MOD_FASTCGI_VERSION=2.4.6
# goofy vulcan output naming convention
output_name=/tmp/mod_fastcgi-2.4.tgz
_tgz=${SRC_DIR}/mod_fastcgi-${MOD_FASTCGI_VERSION}.tgz
_src=${SRC_DIR}/mod_fastcgi-${MOD_FASTCGI_VERSION}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://util.cloud.tourbuzz.net/sources/apache/mod_fastcgi-${MOD_FASTCGI_VERSION}.tar.gz"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available: ${_src}." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "mkdir -p /app/apache && curl http://util.cloud.tourbuzz.net/heroku/builds/httpd-2.2.tgz | tar -zxvf - -C /app/apache \
        && cp Makefile.AP2 Makefile \
        && make top_dir=/app/apache install \
    " \
    -p /app/apache

echo Copying tgz to ${BUILD_DIR}
mv ${output_name} ${BUILD_DIR}/
