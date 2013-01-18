#!/bin/sh
. ./vulcan-helpers.sh

SVN_VERSION=1.7.8
# goofy vulcan output naming convention
output_name=/tmp/subversion-1.7.tgz
name=subversion-${SVN_VERSION}
_tgz=${SRC_DIR}/subversion-${SVN_VERSION}.tgz
_src=${SRC_DIR}/subversion-${SVN_VERSION}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://www.globalish.com/am/subversion/subversion-${SVN_VERSION}.tar.gz"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "mkdir -p /app/apache && curl -s http://util.cloud.tourbuzz.net.s3.amazonaws.com/heroku/builds/apache_mod_fastcgi-2.2.22.tgz | tar -zxvf - -C /app/apache \
       && mkdir -p sqlite-amalgamation && curl -s http://www.sqlite.org/sqlite-autoconf-3071502.tar.gz | tar xz -O sqlite-autoconf-3071502/sqlite3.c > sqlite-amalgamation/sqlite3.c \
       && ./configure  \
            --prefix=/app \
            --with-apr=/app/apache \
            --with-apr-util=/app/apache \
       && make install
    " \
    -p /app/vendor/subversion-${SVN_VERSION} \
&& echo Copying binary tgz to ${BUILD_DIR} \
&& mv ${output_name} ${BUILD_DIR}/
