$(document).ready(function() {
  $("#submit").on("click", function() {

    $.getJSON("/checks").then(date => {
      let inv = $("#input").val();
      $(".prize").remove("");
      for (i = 0; i < 7; i++) {
        $(".prize").remove("");
        let string = date[i].inter.substr(-3);
        if (inv == string) {
          $(".messege").append(`<div class="prize">中獎 ${inv}</div>`)
          $(".messege").append(`<div class="prize">繼續對對看  ${date[i].inter}</div>`);
          {break;}
        } else {
          $(".messege").append(`<div class="prize">未中獎 ${inv}</div>`);
        }
      }
      $("#input").val("");
    });
  });
});
