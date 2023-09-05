FROM php:7-apache

ARG user
ARG uid
    
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nano \
    default-mysql-client \
    libmcrypt-dev
    
RUN pecl install xdebug-3.0.4 && \
    docker-php-ext-enable xdebug

RUN pecl install mcrypt && \
    docker-php-ext-enable mcrypt


RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd mysqli soap

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY docker-compose/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY docker-compose/php/conf.d/error_reporting.ini /usr/local/etc/php/conf.d/error_reporting.ini

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www

USER $user
