FROM php:7.4-apache

RUN apt-get update && \
	apt-get install -y vim
	
COPY apache2-foreground /usr/local/bin/
COPY templates /var/apache2/templates
COPY conf/ /etc/apache2
COPY serf /usr/local/bin

RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
RUN a2ensite 000-* 001-*