import flatpickr from 'flatpickr'
import { MandarinTraditional } from "flatpickr/dist/l10n/zh-tw"

console.log(MandarinTraditional)

document.addEventListener('turbolinks:load', () => {
  flatpickr.localize(MandarinTraditional)

  flatpickr('#start_date', {})

  flatpickr('#end_date', {
    defaultDate: "today",
    maxDate: "today",
  })
})
