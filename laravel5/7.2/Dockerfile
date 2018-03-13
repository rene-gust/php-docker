FROM php:7.2-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
RUN    apk update \
    && apk upgrade \
    # ICU
    && apk add --no-cache libintl icu \
    && apk add -t .icu-build-deps icu-dev \
    && docker-php-ext-install intl \
    && apk del .icu-build-deps \
    # opcache
    && docker-php-ext-install opcache \
    # PDO
    && docker-php-ext-install pdo \
    # PDO MySQL
    && apk add --no-cache mariadb-client-libs \
    && apk add --no-cache -t .mysql-build-deps mariadb-dev \
    && docker-php-ext-install pdo_mysql \
    && apk del .mysql-build-deps \
    # install redis for sessions
    && apk add --no-cache --virtual .redis-build-deps $PHPIZE_DEPS \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && apk del .redis-build-deps \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
