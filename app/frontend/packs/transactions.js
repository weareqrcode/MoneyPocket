import flatpickr from 'flatpickr'; // 別人的函式庫先上面，在放自己的js檔
import $ from "jquery";
// import '../sweetalert.js';

$(document).on('turbolinks:load', function() {
  $('#start_date').off('click')
                  .on('click', function() {
                    flatpickr('#start_date', {})
                  });
  $('#end_date').off('click')
                .on('click', function() {
                  flatpickr('#end_date', {})
                });
})

