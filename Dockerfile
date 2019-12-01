FROM php:7.3-fpm AS production

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
RUN install -m 0750 -o www-data -g www-data -d /sessions && \
    install -m 0750 -o www-data -g www-data -d /documents

ENTRYPOINT [ "docker-entrypoint" ]
CMD [ "php-fpm" ]

WORKDIR /www

VOLUME [ "/www", "/documents", "/scripts", "/sessions" ]

FROM production AS debug

RUN pecl install xdebug && docker-php-ext-enable xdebug