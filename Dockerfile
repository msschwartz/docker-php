FROM php:7.0

WORKDIR /root

RUN apt-get update
RUN apt-get install wget python git ssh tar gzip ca-certificates -y

# gcloud
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN tar -zxvf google-cloud-sdk-230.0.0-linux-x86_64.tar.gz
RUN /root/google-cloud-sdk/install.sh --quiet
RUN /root/google-cloud-sdk/bin/gcloud components install kubectl --quiet
RUN ln -s /root/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
RUN ln -s /root/google-cloud-sdk/bin/kubectl /usr/local/bin/kubectl

# docker
RUN curl -L -o /tmp/docker-17.03.0-ce.tgz https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz
RUN tar -xz -C /tmp -f /tmp/docker-17.03.0-ce.tgz
RUN mv /tmp/docker/* /usr/bin

# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.6.5 
RUN mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer config --global secure-http false
