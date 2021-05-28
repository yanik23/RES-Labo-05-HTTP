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
			
			
			
			
			
			
			
			
			
			
			