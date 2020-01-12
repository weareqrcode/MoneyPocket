import flatpickr from 'flatpickr'
import { MandarinTraditional } from "flatpickr/dist/l10n/zh-tw"
import moment from 'moment'

document.addEventListener('turbolinks:load', () => {
  flatpickr.localize(MandarinTraditional)

  flatpickr('#start_date', {})

  flatpickr('#end_date', {
    defaultDate: "today",
    maxDate: moment().endOf('day').fromNow()
  })
})
