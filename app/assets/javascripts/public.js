$( document ).ready(function() {
  $(".alert-info").fadeTo(2000, 500).slideUp(500, function(){
    $(".alert-info").alert('close');
  });
});
