FROM php:7.4-apache

RUN apt-get update && \
	apt-get install -y vim
	
COPY content/ /var/www/html/

COPY serf /usr/local/bin

RUN chmod +x /usr/local/bin/serf




