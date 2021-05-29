FROM php:7.4-apache

RUN apt-get update && \
	apt-get install -y vim
	
COPY apache2-foreground /usr/local/bin/
COPY templates /var/apache2/templates
COPY conf/ /etc/apache2
COPY serf /usr/local/bin
COPY event_handler.sh /usr/local/bin

RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests status
RUN a2ensite 000-* 001-*

RUN ["chmod", "+x", "/usr/local/bin/docker-php-entrypoint"]
RUN ["chmod", "+x", "/usr/local/bin/apache2-foreground"]
RUN ["chmod", "+x", "/usr/local/bin/event_handler.sh"]


RUN chmod +x /usr/local/bin/serf
