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
Dans cette partie nous devions implémenter un reverse proxy apache (en configuration static)

configuration de base 
pour configurer un simple reverse proxy il faut avoir les modules apache correct instalé
ces derniers sont activé via le docker file 
```
RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
RUN a2ensite 000-* 001-*
```

configurer notre site pour qu'il utilise le reverse proxy
```
<VirtualHost *:80>
	ServerName demo.res.ch
	
	ProxyPass "/api/students/" "http://172.17.0.3:3000/"
	ProxyPassReverse "/api/students/" "http://172.17.0.3:3000/"
	
	ProxyPass "/" "http://172.17.0.2:80/"
	ProxyPassReverse "/" "http://172.17.0.2:80/"	
</VirtualHost>

```


## construire les images docker depuis la racine 
```
Docker build -t res/jl_apache_php docker-images/apache-php-image/
Docker build -t res/jl_express_dynamic docker-images/express-image/
Docker build -t res/jl_apache_rp docker-images/apache-reverse-proxy/
```

## demarer les conteneur
__Attention__ on considère que il ya aucun autre conteneur de démarré, pour que la configuration marche telle que représenté ci dessus il faut demarer dans cet ordre spécifique, sans aucun autre conteneur de démarré dans docker
```
Docker run -d --name jl_static res/jl_apache_php
Docker run -d --name jl_dynamic res/jl_express_dynamic
Docker run -d -p 8080:80 --name jl_apache_rp res/jl_apache_rp

```

pour désormais accéder a notre site on peut acceder á l'url suivant demo.res.ch:8080

on peut effectivement voir aussi si on tente d'accéder aux serveurs statique et dynamique individuellement, ça ne marche pas.

## Mauvaise idée de configurer un site comme cela
configurer notre site comme cela est très hasardeux car supposon que l'on démarre d'autre conteneur dans docker les adresses IP seront différente, alors il faudrai a chaque fois changer les adresses dans le fichier config de notre site pour qu'il soient à jour.


## Step 4: AJAX requests with JQuery
### branche : fb-ajax-jquery

## construire les images docker depuis la racine 
```
Docker build -t res/jl_apache_php docker-images/apache-php-image/
Docker build -t res/jl_express_dynamic docker-images/express-image/
Docker build -t res/jl_apache_rp docker-images/apache-reverse-proxy/
```

## demarer les conteneur
__Attention__ on considère que il ya aucun autre conteneur de démarré, pour que la configuration marche telle que représenté ci dessus il faut demarer dans cet ordre spécifique, sans aucun autre conteneur de démarré dans docker
```
Docker run -d --name jl_static res/jl_apache_php
Docker run -d --name jl_dynamic res/jl_express_dynamic
Docker run -d -p 8080:80 -p 3000:3000 --name jl_apache_rp res/jl_apache_rp

```
pour désormais accéder a notre site on peut acceder á l'url suivant demo.res.ch:8080

on va envoyer une requete a notre serveur dynamique toute les 2 secondes, ensuite on récupère le premier élément de notre objet json retourné. Et on l'affecte dans notre page HTML
dans notre cas les balises contenant la classe `.masthead-subheading` auront leurs contenu remplacé par des animeaux (:

```js
(function ($) {
	console.log("Loading animals");
	
	function loadAnimals() {
		$.getJSON("/api/animals/", function(animals) {
			console.log(animals);
			var message = "Nobody is here";
			
			if(animals.length > 0) {
				message = animals[0].name + " the " + animals[0].type;
			}
			$(".masthead-subheading").text(message);
		});
	};
	
	loadAnimals();
	setInterval(loadAnimals, 2000);
})(jQuery);
```

## Step 5: Dynamic reverse proxy configuration
### branche : fb-dynamic-configuration
## construire les images docker depuis la racine 
```
Docker build -t res/jl_apache_php docker-images/apache-php-image/
Docker build -t res/jl_express_dynamic docker-images/express-image/
Docker build -t res/jl_apache_rp docker-images/apache-reverse-proxy/
```

## demarer les conteneur
__Attention__ on considère que il ya aucun autre conteneur de démarré, pour que la configuration marche telle que représenté ci dessus il faut demarer dans cet ordre spécifique, sans aucun autre conteneur de démarré dans docker
```
Docker run -d --name jl_static res/jl_apache_php
Docker run -d --name jl_dynamic res/jl_express_dynamic
Docker run -d -e STATIC_APP=172.17.0.3 -e DYNAMIC_APP=172.17.0.2 -p 8080:80 --name jl_apache_rp res/jl_apache_rp

```
pour désormais accéder a notre site on peut acceder á l'url suivant demo.res.ch:8080

## configuration
pour cette étape on dois creer des variables d'environnement dans notre conteneur. `STATIC_APP` et `DYNAMIC_APP`, ces dernier sont créer avec les paramètre -e lors d'un `docker run`

en exécutant le fichier apache2-foreground on va exécuter le code php au démarage de notre conteneur, et écrire dans le fichier de configuration de notre site web, les adresses IP pour notre proxy seront alors injecté correctement.



## fichier template
```php
<?php
	$dynamic_app = getenv('DYNAMIC_APP');
	$static_app = getenv('STATIC_APP');
?>
<VirtualHost *:80>
	ServerName demo.res.ch
	
	ProxyPass '/api/animals/' 'http://<?php print "$dynamic_app"?>/'
	ProxyPassReverse '/api/animals/' 'http://<?php print "$dynamic_app"?>/'
	
	ProxyPass '/' 'http://<?php print "$static_app"?>/'
	ProxyPassReverse '/' 'http://<?php print "$static_app"?>/'	
</VirtualHost>
```


## Additional Setps : Load balancing multiple server nodes
### branche : fb-load-balancer
