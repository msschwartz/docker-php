FROM centos:centos7
MAINTAINER Michael Schwartz "msschwartz@outlook.com"

# Import Remi Repository
RUN yum --assumeyes install \
    yum-utils \
    wget \
    epel-release \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager -q --enable remi \
    && yum-config-manager -q --enable remi-php56

# General
WORKDIR /tmp/
ENV HOME /root

RUN yum --assumeyes install \
    git-core tar bzip2 unzip net-tools which \
    && yum clean all

# PHP
RUN yum --assumeyes install \
    php-fpm php-cli \
    php-bcmath php-intl php-mbstring php-opcache php-xml php-gmp \
    php-mcrypt php-openssl php-pecl-libsodium \
    php-pdo php-mysql php-mssql php-pgsql \
    php-ldap php-soap \
    php-pecl-apcu php-pecl-memcache php-pecl-xdebug \
    && yum clean all

ENV COMPOSER_NO_INTERACTION 1
ENV COMPOSER_ALLOW_SUPERUSER 1
COPY composer.json $HOME/.composer/config.json

# Node
ENV NODE_VERSION 8.9.4
ENV NPM_VERSION 5.6.0

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
    && npm install -g npm@"$NPM_VERSION"

COPY .npmrc $HOME/.npmrc
COPY .bowerrc $HOME/.bowerrc

# CLEAN UP
WORKDIR $HOME
RUN yum clean all

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# blank directory
RUN mkdir -p /var/www/app

CMD ["/bin/sh"]
