$(function() {
  $('.move_mode').draggable({ containment: '.board'});
  $( '.piece' ).droppable({
    drop: function( event, ui ) {
      $(ui.draggable).detach().css({top: 0,left: 0});
      $(this).replaceWith(ui.draggable);
      var draggableId = ui.draggable.attr("id");
      var droppableId = $(this).attr("pos");
      var updateUrl = "/pieces/" + draggableId
      var row = droppableId[0];
      var col = droppableId[1];

      $.ajax({
        type: 'PUT',
        url: updateUrl,
        dataType: 'json',
        data: { piece: { 
                row_position: row, 
                col_position: col 
        }},
        complete: function(){
          location.reload(true);
        }
      });
    }     
  });

  var pusher = new Pusher('69b758b613152645a0ba', {
      encrypted: true
  });  

  var gameId = $('.pusherInfo').data('pusherinfo');

  var channel = pusher.subscribe(gameId);

  channel.bind('update-piece', function(data) {
    location.reload(true);
  });
});

$(function() {
  if ($('#data').data('key1')) {
    $('#winModal').modal('show');
  };
});