#!/bin/bash

declare -A php_versions
php_versions=(["7.0"]="7.0-fpm-alpine"
              ["7.1"]="7.1-fpm-alpine"
              ["7.2"]="7.2-fpm-alpine3.7")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for framework in "symfony3"
do
    for subdir in ${DIR}/${framework}/*/
    do
        version=$(basename $subdir)
        file="${subdir}Dockerfile"
        echo "FROM php:${php_versions[$version]}" > $file
        echo "MAINTAINER Linus Lotz<l.lotz@reply.de>" >> $file
        cat $DIR/$framework/Dockerfile.base >> $file
    done
done
