FROM php:5.6-cli

MAINTAINER "Dylan Miles" <dylan.g.miles@gmail.com>

WORKDIR /tmp

#Install extensions
RUN apt-get update -y && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmcrypt-dev \
        libcurl4-gnutls-dev \
    && docker-php-ext-install -j$(nproc) curl \        
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) pcntl

#Install curl 
RUN apt-get install -y curl


#Install composer
RUN curl -o composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update
    
#Force composer package list to use https
RUN composer config --global repos.packagist composer https://packagist.org
    
#RUN apt-get remove --purge curl -y && \
#    apt-get clean

RUN mkdir -p /data/www
VOLUME ["/data"]
WORKDIR /data/www

ENTRYPOINT ["composer"]
CMD ["--help"]
