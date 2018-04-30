FROM ubuntu:12.04

#Argumentos & ENV
#ARG Entorno
#ENV Entorno=$Entorno

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y git curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql

#Install AWS CLI
RUN apk-install python3 openssl groff && \
  wget -O /tmp/awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
  unzip -d /tmp/ /tmp/awscli-bundle.zip && \
  python3 /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
  rm -f /tmp/awscli-bundle.zip && \
  rm -rf /tmp/awscli-bundle

# Install app
RUN rm -rf /var/www/*
ADD src /var/www
COPY src/entrypoint.sh /usr/local/bin/
RUN chmod 777 /var/www/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh

#Info Page
#RUN echo $Entorno > /var/www/info.php

# Configure apache
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
