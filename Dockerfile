FROM php:7.0-apache

WORKDIR /root

RUN apt-get update
RUN apt-get install wget python -y

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN tar -zxvf google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN /root/google-cloud-sdk/install.sh --quiet
RUN /root/google-cloud-sdk/bin/gcloud components install kubectl --quiet
RUN echo "export PATH=/root/google-cloud-sdk/bin:$PATH" >> ~/.bashrc

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.6.5 
RUN mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer config --global secure-http false
