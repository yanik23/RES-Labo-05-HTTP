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