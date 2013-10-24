$(document).ready(function() {
  
  $('#myModal').modal('toggle');
  
  $(document).on('click', '#hit input', function() {
    $.ajax({
      type: 'POST',
      url: "/game/player/hit" 
    }).done(function(msg) {
      $('#game').replaceWith(msg);
      $('#myModal').modal('toggle');
    });
    return false;
  }); 

  $(document).on('click', '#stay input', function() {
    $.ajax({
      type: 'POST',
      url: "/game/player/stay"
    }).done(function(msg) {
      $('#game').replaceWith(msg);
      $('#myModal').modal('toggle');
    });
    return false;
  });

  $(document).on('click', '#dealerhit input', function() {
    $.ajax({
      type: 'POST',
      url: "/game/dealer"
    }).done(function(msg) {
      $('#game').replaceWith(msg);
      $('#myModal').modal('toggle');
    });
    return false;
  });

});

