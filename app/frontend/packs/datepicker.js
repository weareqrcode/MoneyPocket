import 'flatpickr/dist/flatpickr.min.css';

import flatpickr from 'flatpickr';

document.addEventListener('turbolinks:load', function(){
  flatpickr('#start_date', {})
  flatpickr('#end_date', {})
})