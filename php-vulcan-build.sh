#!/bin/sh
. ./vulcan-helpers.sh

PHP_VERSION=5.3.21
_tgz=php-${PHP_VERSION}.tgz
_src=php-${PHP_VERSION}
[[ ! -d $_src ]] && [[ ! -f $_tgz ]] && curl -o ./download_temp/${_tgz} --location "http://us1.php.net/get/php-${PHP_VERSION}.tar.gz/from/us1.php.net/mirror"
[[ ! -d $_src ]] && tar -zxf ./download_temp/${_tgz} -C ./download_temp
[[ ! -d $_src ]] && echo "Source code not locally available." && exit 1
vulcan build -v \
    -s ./download_temp/php-${PHP_VERSION} \
    -c "./configure  \
            --prefix=/app/vendor/php-${PHP_VERSION} \
            --without-pear  \
            --enable-pcntl  \
            --with-curl  \
            --with-pgsql  \
            --enable-pdo  \
            --with-pdo-pgsql  \
        && make install
    " \
    -p /app/vendor/php-${PHP_VERSION}
