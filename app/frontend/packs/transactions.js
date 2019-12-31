import flatpickr from 'flatpickr';
import $ from "jQuery";
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
