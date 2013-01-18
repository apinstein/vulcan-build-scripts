mkdir -p ./build/src
cd ./build
BUILD_DIR=`pwd`
SRC_DIR=`pwd`
# @todo refactor dirs to that src tgz and bin tgz not in same place; vulcan wasn't cooperating
#SRC_DIR=`pwd`/src

# @todo make sure these work later...
#function ensure_file_exists($local, $fetch) {
#    [[ ! -f $local ]] && curl -O ${local} http://us1.php.net/get/php-${fetch}.tar.gz/from/us1.php.net/mirror
#}
#
#function ensure_tgz_extracted($tgz) {
#    [[ -f $_src ]] || tar -zxf ${_tgz}
#}
