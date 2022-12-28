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

ARG MYSQL_HOST=172.17.0.1
ARG MYSQL_DATABASE=cspro
ARG MYSQL_USER=cspro
ARG MYSQL_PASSWORD=cspro
ARG DEFAULT_TIMEZONE=UTC

# Config CSWeb
RUN set - eux; \
    echo "<?php \
    define('DBHOST', '$MYSQL_HOST'); \
    define('DBUSER', '$MYSQL_USER'); \
    define('DBPASS', '$MYSQL_PASSWORD'); \
    define('DBNAME', '$MYSQL_DATABASE'); \
    define('ENABLE_OAUTH', true); \
    define('FILES_FOLDER', '/var/www/html/files'); \
    define('DEFAULT_TIMEZONE', 'UTC'); \
    define('MAX_EXECUTION_TIME', '300'); \
    define('API_URL', 'http://localhost/api/'); \
    define('CSWEB_LOG_LEVEL' , 'error'); \
    define('CSWEB_PROCESS_CASES_LOG_LEVEL', 'error'); \
    ?>" > /var/www/html/src/AppBundle/config.php