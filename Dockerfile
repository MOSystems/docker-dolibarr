FROM php:7.3-fpm

RUN apt-get update && apt-get install -y \
    # needed for postgresql database
    libpq-dev \   
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
    # needed for postgresql database
    pgsql \
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

ARG version
ARG checksum
RUN curl -L https://github.com/Dolibarr/dolibarr/archive/${version}.tar.gz -o /tmp/dolibarr.tar.gz 2>&1 \
    && echo "${checksum}  /tmp/dolibarr.tar.gz" | sha1sum -c -
RUN mkdir /documents && chown www-data:www-data /documents \
    && mkdir /sessions && chown www-data:www-data /sessions \
    && mkdir /www && tar --totals -C /www -xzf /tmp/dolibarr.tar.gz --strip-components=2 --wildcards */htdocs \
    && chown -R www-data:www-data /www && chmod -R a=rX /www \
    && mkdir /scripts && tar --totals -C /scripts -xzf /tmp/dolibarr.tar.gz --strip-components=2 --wildcards */scripts \
    && chown -R www-data:www-data /scripts \
    && rm /tmp/dolibarr.tar.gz

ARG debug=false
RUN if [ "$debug" = "true" ]; then pecl install xdebug && docker-php-ext-enable xdebug; fi

COPY ./src/ /

ENTRYPOINT [ "docker-entrypoint" ]
CMD [ "php-fpm" ]

WORKDIR /www

VOLUME [ "/www", "/documents", "/scripts", "/sessions" ]