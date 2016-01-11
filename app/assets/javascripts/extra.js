$('document').ready(function() {
  setTimeout(function() {
    $('.flash').slideUp();
  }, 3000);

  $('#check-source').click(function(){
	    var link = $(this);
	    $('#check-panel').slideToggle('medium', function() {
	    	if ($(this).is(":visible")) {
	            link.text('(hide source)');                
	        } else {
	            link.text('(view source)');                
	        }        
	    });            
	});

  $('#drag-drop').click(function(){
	    var link = $(this);
	    $('#drag-panel').slideToggle('medium', function() {
	    	if ($(this).is(":visible")) {
	            link.text('(hide source)');                
	        } else {
	            link.text('(view source)');                
	        }        
	    });            
	});
});