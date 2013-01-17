# WARNING sourceforge sucks so you have to grab a time-stamped URL or manually put the file in the right place.
echo NOT WORKING BUT A NICE START
exit 1

MCRYPT_VERSION=2.6.8
_tar=~/Downloads/mcrypt-${MCRYPT_VERSION}.tar
_src=mcrypt-${MCRYPT_VERSION}
[[ ! -f $_tar ]] && echo "Go download this file from sourceforge to this directory: http://sourceforge.net/projects/mcrypt/files/MCrypt/${MCRYPT_VERSION}/mcrypt-${MCRYPT_VERSION}.tar.gz/download" && exit 1
[[ ! -d $_src ]] && [[ -f $_tar ]] && mkdir -p ${_src} && tar -xf ${_tar} -C .
[[ ! -d $_src ]] && echo "Source code directory ${_src} unavailable." && exit 1
vulcan build -v \
    -s ./mcrypt-${MCRYPT_VERSION} \
    -p /app/vendor/mcrypt-${MCRYPT_VERSION}
