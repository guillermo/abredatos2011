
// What is $(document).ready ? See: http://flowplayer.org/tools/documentation/basics.html#document_ready
$(function() {

$(".slides .slidetabs").tabs("#head ul > li.slide", {

	// enable "cross-fading" effect
	effect: 'fade',
	fadeOutSpeed: "fast",

	// start from the beginning after the last tab
	rotate: true

// use the slideshow plugin. It accepts its own configuration
}).slideshow();

$(".slides .slidetabs").data("slideshow").play();
});
