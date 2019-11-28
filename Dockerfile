FROM php:7.3-fpm

RUN apt-get update && apt-get install -y \
    libgd-dev \
    libmcrypt-dev \
    libzip-dev \
    libcurl4 \
    libxml2-dev \
    libicu-dev \
    libldap2-dev \
    # needed for sending emails
    sendmail

RUN docker-php-ext-install -j$(nproc) \
    # needed for mysql database
    mysqli \ 
    gd \
    soap \
    zip \
    intl \
    ldap \
    && pecl install mcrypt \
    && docker-php-ext-enable \
    mcrypt

RUN ln -s "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./src/ /
COPY --chown=www-data:www-data ./vendor/dolibarr/htdocs/ /www/
COPY --chown=www-data:www-data ./vendor/dolibarr/scripts/ /scripts/

ENTRYPOINT [ "docker-entrypoint" ]
CMD [ "php-fpm" ]

WORKDIR /www

VOLUME [ "/www", "/documents", "/scripts", "/sessions" ]