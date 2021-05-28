# RES-Labo-05-HTTP
Laboratoire HTTP Infrastructure du cours RES

## Step 1: Static HTTP server with apache httpd
#### branche : fb-apache-static

Dans cette étape nous devions configurer un serveur http statique.
Pour commencer nous avons crée un dossier **/apache-php-image**  dans un dossier **/docker-images** qui contiendra tout ce qui est nécessaire pour pouvoir créer une image docker d'un serveur **http statique**. 
Toujours dans notre dossier **/apache-php-image** nous avons crée notre fichier **Dockerfile** et un dossier **/content** qui contiendra un template web.

Pour le **Dockerfile** nous avons pris l'image officielle php [suivante](https://hub.docker.com/_/php). Notre **Dockerfile** ressemble à quelque chose comme ceci :

```
FROM php:7.4-apache

COPY content/ /var/www/html/
```

Pour le contenu web on a choisi le template html [suivant](https://startbootstrap.com/theme/agency) qu'on a mis à l'intérieur d'un dossier **/content**.

Ensuite il suffit d'ouvrir un terminal dans le dossier où se trouve notre **Dockerfile** et de construire l'image :
```
docker build -t res/apache_php .
```
Et de lancer on container en mappant un port au port http 80:
```
docker run -it -p 8080:80 res/apache_php
```
Maintenant si on ouvre un navigateur web et on écrit ``` localhost:8080``` on devrait avoir notre site html qui devrait s'afficher.



## Step 2: Dynamic HTTP server with express.js
#### branche : fb-express-dynamic

Dans cette étape nous devions configurer un serveur http dynamique.
Pour commencer nous avons crée un nouveau dossier ```/express-image``` de nouveau dans le dossier **/docker-images** qui contiendra tout ce qui est nécessaire pour notre image docker du serveur **http dynamique**.
Dans ce dossier nous avons crée comme avant un **Dockerfile** et avons pris l'image docker officielle [node.js](https://hub.docker.com/_/node) :

```
FROM node:14.17.0


COPY src /opt/app

CMD ["node", "/opt/app/index.js"]
```

Comme dans le **Dockerfile** on copie le contenu du dossier **/src** vers **/opt/app** il faudra avoir crée au préalable le dossier **/src** dans le même dossier que le **Dockerfile**. Il faut également avoir installé [node.js](https://nodejs.org/en/).
Une fois ceci fait on peut lancer la commande (dans un terminal) ```npm init``` dans le dossier où l'on souhaite installer notre package (ici ça sera notre dossier **/src**). 
En plus d'avoir installé node.js il nous faudra quelques compléments comme :

 - le module [chance](https://chancejs.com/usage/node.html)
 - [express.js](https://expressjs.com/fr/)
 - [express generator](https://expressjs.com/fr/starter/generator.html)
 
Pour installer les modules il suffit de se mettre dans le dossier où l'on souhaite les installer (dossier **/src** dans notre cas) et on lance les commandes :
- `npm install chance --save `
- `npm install express -- save`
- `npm install express-generator -g` (ici -g car on veut une installation générale car on va utiliser souvent ce module dans le future.

Maintenant créeons un fichier `index.js` dans notre dossier `/src` qui va nous retourner notre json d'animaux (un choix fait par nous, on aurait pu aussi retourner des étudiants, chats ou autre) :
```js
  
var Chance = require('chance');
var chance = new Chance();

//console.log("Bonjour " + chance.name())

var express = require('express');
var app = express();


app.get('/test', function(req, res){
	res.send("Hello RES - test");
});


app.get('/', function(req, res){
	res.send(generateAnimals());
});

app.listen(3000, function() {
	console.log('Accepting HTTP requests on port 3000.');
});

function generateAnimals() {
	var numberOfAnimals = chance.integer({
		min: 0,
		max: 10
	});
	console.log(numberOfAnimals);
	var animals = []
	for(var i = 0; i < numberOfAnimals; i++){
		
		var gender = chance.gender();
		var birthYear = chance.year({
			min: 2000,
			max: 2020
		});
		animals.push({
			name: chance.first({
				gender: gender
			}),
			type : chance.animal(),
			gender: gender,
			birthday: chance.birthday({
				year: birthYear
			})
		});
	};
	console.log(animals);
	return animals;
}
````

Pour tester qu'on reçoit bien notre json d'animaux il suffit de lancer un container après avoir construit l'image docker et de lancer un netcat sur le port 3000.
Ensuite il suffit de lancer la requête HTTP suivante `GET / HTTP/1.0` faire 2 retours à la ligne et remarquer que nous avons reçu un json d'animaux.

## Step 3: Reverse proxy with apache (static configuration)
### branche : fb-express-dynamic



## Step 4: AJAX requests with JQuery
### branche : fb-ajax-jquery



## Step 5: Dynamic reverse proxy configuration
### branche : fb-dynamic-configuration

## Additional Setps : Load balancing multiple server nodes
### branche : fb-load-balancer
