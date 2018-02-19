FROM php:7.2-fpm-alpine3.7
MAINTAINER Linus Lotz<l.lotz@reply.de>
RUN    apk update \
    && apk upgrade \
    && apk add --no-cache libintl icu \
    && apk add -t .icu-build-deps icu-dev \
    && docker-php-ext-install intl \
    && apk del .icu-build-deps \

    && docker-php-ext-install opcache \

    # PDO
    && docker-php-ext-install pdo \

    # PDO MySQL
    && docker-php-ext-install pdo_mysql \

    # PDO PgSQL
    && apk add --no-cache postgresql-libs \
    && apk add --no-cache -t .psql-build-deps postgresql-dev \
    && docker-php-ext-install pdo_pgsql \
    && apk del .psql-build-deps \

    # install redis for sessions
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \

    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
