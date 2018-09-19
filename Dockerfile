FROM ubuntu:trusty

MAINTAINER Michael Schwartz <msschwartz@outlook.com>

WORKDIR /var/www/html

RUN apt-get update

# curl
RUN apt-get install -y curl

# apache
RUN apt-get install -y apache2
RUN a2enmod rewrite

# php
RUN apt-get install -y php5 libapache2-mod-php5 php5-fpm php5-cli php5-xdebug
RUN apt-get install -y php5-mssql php5-mysqlnd php5-pgsql php5-sqlite php5-redis
RUN apt-get install -y php5-apcu php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl php5-tidy
RUN apt-get install -y memcached php5-memcached php5-memcache
RUN php5enmod mcrypt memcache memcached pdo pdo_mysql pdo_pgsql pdo_sqlite pdo_dblib

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.6.5 
RUN mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer config --global secure-http false

# conf
COPY ./apache2.conf /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
