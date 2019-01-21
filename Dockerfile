FROM circleci/php:7.0-stretch-node-browsers-legacy

WORKDIR /home/circleci

RUN apt-get update
RUN apt-get install wget python git -y

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN tar -zxvf google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN /home/circleci/google-cloud-sdk/install.sh --quiet
RUN /home/circleci/google-cloud-sdk/bin/gcloud components install kubectl --quiet

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.6.5 
RUN mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer config --global secure-http false
