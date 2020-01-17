import flatpickr from 'flatpickr';
import $ from "jquery";

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
