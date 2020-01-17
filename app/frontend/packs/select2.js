import $ from 'jquery';
import 'select2';

$(() => {
  $('.select2-enable').select2();
});

$(document).on('turbolinks:load', function () {
  $("#post_tag_items").select2({
    tags: true,
    tokenSeparators: [',', ' ']
  })
});
