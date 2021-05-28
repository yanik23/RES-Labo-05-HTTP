# RES-Labo-05-HTTP
Laboratoire HTTP Infrastructure du cours RES

## Step 1: Static HTTP server with apache httpd
#### branche : fb-apache-static

Dans cette étape nous devions configurer un serveur http statique.
Pour commencer nous avons créer un dossier **/apache-php-image** qui contiendra tout ce qui est nécessaire pour pouvoir créer une image docker d'un serveur http statique.
Toujours dans notre dossier **/apache-php-image** nous avons crée notre fichier **Dockerfile** et un dossier **/content** qui contiendra un template web.

Pour le **Dockerfile** nous avons pris l'image officielle php [suivante](https://hub.docker.com/_/php). Notre **Dockerfile** ressemble à quelque chose comme ceci :

```
FROM php:7.2-apache

COPY content/dist /var/www/html/
```
Pour cette partie on a choisi le template html [suivant](https://startbootstrap.com/theme/agency) qu'on a mis à l'intérieur d'un dossier content
