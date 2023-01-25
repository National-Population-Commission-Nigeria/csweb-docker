FROM php:7.4-apache

# Use production php settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# php-zip support
RUN set -eux; \
    sed -i "s#deb http://deb.debian.org/debian buster main#deb http://deb.debian.org/debian buster main contrib non-free#g" /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y zlib1g-dev libzip-dev unzip; \
    docker-php-ext-install zip; \
    docker-php-ext-install pdo_mysql

# enable mod_rewrite and allow override from .htacess files
RUN set -eux; \
    a2enmod rewrite; \
    sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copy CSWEB
COPY csweb.zip ./

# Unpack CSWEB
RUN set -eux; \
    unzip csweb.zip -d /var/www/html/; \
    chown -R www-data:www-data /var/www/html; \
    rm csweb.zip

# Config CSWeb
COPY setup.sh ./


# PORTS
EXPOSE 80
EXPOSE 443

# Start
CMD bash ./setup.sh
