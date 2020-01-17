import flatpickr from 'flatpickr'
import { MandarinTraditional } from "flatpickr/dist/l10n/zh-tw"
import moment from 'moment'

document.addEventListener('turbolinks:load', () => {
  flatpickr.localize(MandarinTraditional)

  // var setupFlatpickr = function(){
    flatpickr('#start_date', {disableMobile: true})

    flatpickr('#end_date', {
      disableMobile: true,
      defaultDate: "today",
      maxDate: "today"
    })
  // };
  // setupFlatpickr();
  // window.addEventListener('resize', setupFlatpickr);
})