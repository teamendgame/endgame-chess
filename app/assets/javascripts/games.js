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
        }}
      });
    }     
  });  
});
