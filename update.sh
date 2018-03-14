#!/bin/bash

add_extension () {
    case $1 in

        mysql)
            add_extension pdo
            php_extsions+="mysqli pdo_mysql "
            build_deps+="mariadb-dev "
            run_deps+="mariadb-client-libs "
            ;;
        pgsql|postgres)
            add_extension pdo
            php_extsions+="pdo_pgsql "
            build_deps+="postgresql-dev "
            run_deps+="postgresql-libs "
            ;;
        xml)
            php_extsions+="xml "
            build_deps+="libxml2-dev "
            run_deps+="libxml2 "
            ;;
        intl)
            php_extsions+="intl "
            build_deps+="libicu-dev "
            run_deps+="libintl icu "
            ;;
        gd)
            php_extsions+="gd "
            run_deps+="libgd "
            build_deps+="freetype-dev libwebp-dev libpng-dev zlib-dev libxpm-dev libjpeg-turbo-dev "
            ;;
        opcache|json|pdo|mbstring|tokenizer|ctype)
            php_extensions+="$1 "
            ;;
        redis)
            pecl_extensions+="$1 "
            ;;
        *)
            echo "Unknown extension $1"
            ;;
    esac
}

declare -A php_versions
php_versions=(["7.0"]="7.0-fpm-alpine"
              ["7.1"]="7.1-fpm-alpine"
              ["7.2"]="7.2-fpm-alpine3.7")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for framework in "symfony3" "laravel5"
do
    pecl_extensions=""
    php_extsions=""
    build_deps=""
    run_deps=""
    for ext in $(cat ${DIR}/${framework}/deps)
    do
        add_extension $ext
    done

    # remove duplicates
    pecl_extensions=$(echo -e "${pecl_extensions// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    php_extensions=$(echo -e "${php_extensions// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    build_deps=$(echo -e "${build_deps// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    run_deps=$(echo -e "${run_deps// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')

    for subdir in ${DIR}/${framework}/*/
    do
        version=$(basename $subdir)
        file="${subdir}Dockerfile"

        echo "FROM php:${php_versions[$version]}" > $file
        echo "MAINTAINER Linus Lotz<l.lotz@reply.de>" >> $file
        echo "ENV RUN_DEPS=\"${run_deps}\"" >> $file
        echo "ENV BUILD_DEPS=\"\${PHPIZE_DEPS} ${build_deps}\"" >> $file
        echo "ENV PECL_EXTS=\"${pecl_extensions}\"" >> $file
        echo "ENV PHP_EXTS=\"${php_extsions}\"" >> $file
        cat $DIR/Dockerfile.base >> $file
    done
done


