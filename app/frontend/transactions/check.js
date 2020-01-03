$(document).ready(function() {
  $("#invot").on("chick", function(){
    (".messege").removeClass("")
  })
  
  
  $("#submit").on("chick", function() {
    let inv = $("#invot").val();
    if (/d{3}$/.exec(inv)) {
      (".messege").append(`<p>${inv}未中獎</p>`);
    } else {

    }
  });
});
