$(document).on("turbolinks:load", function() {
  $("#submit").click(function() {
    $("#optioned").val($("#check_select option:selected").index());
  });

  $("#Ym_" + $("#check_select option:selected").val()).removeClass("d-none");
  $("#check_select").change(function() {
    let checkMonth = $("#check_select option:selected").val();
    $(".Ym_group").addClass("d-none");
    $("#Ym_" + checkMonth).removeClass("d-none");
  });

  $("#inv_input").keyup(function() {
    if (this.value != this.value.replace(/[^0-9\.]/g, ""))
      {this.value = this.value.replace(/[^0-9\.]/g, "");
      }
  });
});
