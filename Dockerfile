FROM circleci/php:5.6-cli-node-browsers

MAINTAINER Michael Schwartz <msschwartz@outlook.com>

RUN sudo apt-get -y update

# install gmp
RUN sudo apt-get -y install libgmp-dev
RUN sudo ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN sudo docker-php-ext-configure gmp
RUN sudo docker-php-ext-install gmp

# isntall soap
RUN sudo apt-get -y install libxml2-dev
RUN sudo docker-php-ext-configure soap
RUN sudo docker-php-ext-install soap
