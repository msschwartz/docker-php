FROM centos:centos6

MAINTAINER Michael Schwartz <msschwartz@outlook.com>

WORKDIR /tmp

################################################################################
# Import Remi Repository
################################################################################

RUN yum --assumeyes install \
    yum-utils \
    wget \
    epel-release \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-6.rpm \
    && yum-config-manager -q --enable remi \
    && yum-config-manager -q --enable remi-php54

################################################################################
# General
################################################################################

RUN yum --assumeyes install \
    git-core tar bzip2 unzip net-tools which \
    && yum clean all

################################################################################
# Apache
################################################################################

RUN yum --assumeyes install httpd

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

COPY apache2.conf /etc/httpd/conf.d/apache2.conf

################################################################################
# PHP
################################################################################
# Duplicate modules for cli and httpd
# Not preferred, but it's the only way I could get it working

RUN yum --assumeyes install \
    `# Core` \
    php54-php php-cli \

    `# Core Utils` \
    php54-php-bcmath php54-php-intl php54-php-mbstring php54-php-mcrypt php54-php-xml \
    php-bcmath php-intl php-mbstring php-mcrypt php-xml \

    `# Database` \
    php54-php-pdo php54-php-mysql php54-php-mssql \
    php-pdo php-mysql php-mssql \

    `# Extras` \
    php54-php-ldap php54-php-soap \
    php-ldap php-soap php54-php-tidy.x86_64 \

    `# PECL` \
    php54-php-pecl-apcu php54-php-pecl-memcache php54-php-pecl-xdebug php54-php-pecl-http1 \
    php-pecl-apcu php-pecl-memcache php-pecl-xdebug php-pecl-http1 \

    && yum clean all

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /opt/remi/php54/root/etc/php.ini
RUN sed -i "s/display_errors =.*/display_errors = On/" /opt/remi/php54/root/etc/php.ini

WORKDIR /var/www/html
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
