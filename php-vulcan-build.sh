#!/bin/sh
. ./vulcan-helpers.sh

PHP_VERSION=5.3.21
# goofy vulcan output naming convention
output_name=/tmp/php-5.3.tgz
name=php-${PHP_VERSION}
_tgz=php-${PHP_VERSION}.tgz
_src=php-${PHP_VERSION}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ${_tgz} --location "http://us1.php.net/get/php-${PHP_VERSION}.tar.gz/from/us1.php.net/mirror"
[[ ! -d $_src ]] && tar -zxf ${_tgz} -C .
[[ ! -d $_src ]] && echo "Source code not locally available." && exit 1
vulcan build -v \
    -s ${_src} \
    -c "./configure  \
            --prefix=/app/vendor/php-${PHP_VERSION} \
            --without-pear  \
            --enable-pcntl  \
            --with-curl  \
            --with-pgsql  \
            --enable-pdo  \
            --with-pdo-pgsql  \
            --with-zlib  \
        && make install
    " \
    -p /app/vendor/php-${PHP_VERSION}

echo Extracting binaries to `pwd`/${name}
mkdir -p ./${name}
tar -C ./${name} -vzxf ${output_name} `tar -ztf ${output_name} | grep "^bin/"`
