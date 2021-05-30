(function ($) {
	console.log("Loading students");
	
	function loadStudents() {
		$.getJSON("/api/students/", function(students) {
			console.log(students);
			var message = "Nobody is here";
			
			if(students.length > 0) {
				message = students[0].firstName + " " + students[0].lastName;
			}
			$(".masthead-subheading").text(message);
		});
	};
	
	loadStudents();
	setInterval(loadStudents, 2000);
})(jQuery);