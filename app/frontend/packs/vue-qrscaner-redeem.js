import TurbolinksAdapter from 'vue-turbolinks'
import { QrcodeStream } from 'vue-qrcode-reader'
import Vue from 'vue/dist/vue.esm'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  new Vue({
    el: '#app',
    components: {
      'qrcode-stream':QrcodeStream,
    },
    data: {
      result: '',
      error: '',
      clicked: false,
      scanedQRCode: []
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
        this.scanedQRCode.push(result)
        let invoiceQRCode = this.scanedQRCode.sort().reverse()

        if (/^[A-Z]{2}\d{8}/.test(invoiceQRCode[0]) && invoiceQRCode.length > 0) {
          let fullInvoiceNumber = invoiceQRCode.join('')

          let number = fullInvoiceNumber.slice(0, 10)
          let dateYear = fullInvoiceNumber.slice(10, 13)
          let dateMonth = fullInvoiceNumber.slice(13, 15)
          let dateDay = fullInvoiceNumber.slice(15, 17)

          document.querySelector('#inv_full_number').value = number
          this.clicked = false

          let form = document.querySelector('#inv_form')
          form.dispatchEvent(new Event('submit', {bubbles: true}))

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
})

