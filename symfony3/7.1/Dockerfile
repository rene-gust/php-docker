FROM php:7.1-fpm-alpine
MAINTAINER Linus Lotz<l.lotz@reply.de>
ENV RUN_DEPS="mariadb-client-libs"
ENV BUILD_DEPS="${PHPIZE_DEPS} mariadb-dev"
ENV PECL_EXTS="redis"
ENV PHP_EXTS="mysqli pdo_mysql "
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache $RUN_DEPS \
    && apk add -t .build-deps $BUILD_DEPS \
    && docker-php-ext-install $PHP_EXTS \
    && pecl install -o -f $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && apk del .build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
