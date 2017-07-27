FROM php:7.0-apache

EXPOSE 80 443

# setting some default env vars
ENV WEB_DOCUMENT_ROOT="/var/www/html/public" \
    SERVICE_NAME="localhost"

RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh/ \
    && echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN apt-get update \
    && apt-get install -y \
    git \
    unzip \
    netcat \
    libxml2-dev libbz2-dev re2c libpng++-dev libmcrypt-dev libmemcached-dev \
    libpng3 libjpeg-dev libvpx-dev zlib1g-dev libgd-dev libssl-dev libgeoip-dev libicu-dev \
    libtidy-dev libxslt1-dev libmagic-dev libexif-dev file git curl wget vim g++ libcurl3-openssl-dev \
    && docker-php-ext-install iconv mcrypt curl dom bz2 gd json mysqli pcntl pdo pdo_mysql phar posix \
    && docker-php-ext-install simplexml soap tidy tokenizer xml xmlrpc \
    && docker-php-ext-install xmlwriter xsl zip bcmath calendar ctype \
    && docker-php-ext-install exif fileinfo intl \
    && pecl install raphf \
    && pecl install propro \
    && docker-php-ext-enable raphf propro \
    && a2enmod rewrite ssl

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuration files
ADD ./conf/php.ini /usr/local/etc/php/
ADD ./ssl /etc/apache2/ssl
ADD ./conf/apache.conf /etc/apache2/sites-enabled/000-default.conf
