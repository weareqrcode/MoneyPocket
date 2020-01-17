import TurbolinksAdapter from 'vue-turbolinks'
import { QrcodeStream } from 'vue-qrcode-reader'
import Vue from 'vue/dist/vue.esm'
import Rails from '@rails/ujs'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  let fullNumber = document.querySelector('#inv_full_number')
  new Vue({
    el: '#app',
    components: {
      'qrcode-stream':QrcodeStream,
    },
    data: {
      result: '',
      error: '',
      clicked: false,
      invoiceQRCode: [],
      fullInvoiceNumber: '',
      number: ''
    },
    methods: {
      clickStatus() {
        this.clicked = !this.clicked
      },
      onDecode(result) {
        this.result = result
        this.inserDataToField(this.result)
      },
      inserDataToField(result) {
        this.invoiceQRCode.push(result)
        this.invoiceQRCode = this.invoiceQRCode.sort().reverse()

        if (/^[A-Z]{2}\d{8}/.test(this.invoiceQRCode[0]) && this.invoiceQRCode.length > 0) {
          this.fullInvoiceNumber = this.invoiceQRCode.join('')

          this.number = this.fullInvoiceNumber.slice(0, 10)
          // let dateYear = fullInvoiceNumber.slice(10, 13)
          // let dateMonth = fullInvoiceNumber.slice(13, 15)
          // let dateDay = fullInvoiceNumber.slice(15, 17)

          fullNumber.value = this.number
          this.clicked = false
          this.invoiceQRCode = []
          // document.querySelector('#inv_form').dispatchEvent(new Event('submit', {bubbles: true}))
          Rails.fire(document.querySelector('#inv_form'), 'submit')
        }
      },
      async onInit (promise) {
        try {
          await promise
        } catch (error) {
          if (error.name === 'NotAllowedError') {
            this.error = "ERROR: you need to grant camera access permisson"
          } else if (error.name === 'NotFoundError') {
            this.error = "ERROR: no camera on this device"
          } else if (error.name === 'NotSupportedError') {
            this.error = "ERROR: secure context required (HTTPS, localhost)"
          } else if (error.name === 'NotReadableError') {
            this.error = "ERROR: is the camera already in use?"
          } else if (error.name === 'OverconstrainedError') {
            this.error = "ERROR: installed cameras are not suitable"
          } else if (error.name === 'StreamApiNotSupportedError') {
            this.error = "ERROR: Stream API is not supported in this browser"
          }
        }
      }
    },
  })

  document.addEventListener('keyup', (evt) => {
    if (evt.code === "Enter") {
      // document.querySelector('#inv_form').dispatchEvent(new Event('submit'))
      Rails.fire(document.querySelector('#inv_form'), 'submit')
    }
  })
})

