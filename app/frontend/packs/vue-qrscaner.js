import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import { QrcodeStream } from 'vue-qrcode-reader'
const R = require('ramda')

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
      isScanned: false,
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
        this.scanedQRCode.push(result.trim())
        // let invoiceQRCode = this.scanedQRCode.filter(this.unique).sort().reverse()
        let invoiceQRCode = this.scanedQRCode.sort().reverse()


        if (/^[A-Z]{2}\d{8}/.test(invoiceQRCode[0]) && invoiceQRCode.length === 2) {
          let fullInvoiceNumber = invoiceQRCode.join('')

          let number = fullInvoiceNumber.slice(0, 10)
          let Year = fullInvoiceNumber.slice(10, 13)
          let Month = fullInvoiceNumber.slice(13, 15)
          let Day = fullInvoiceNumber.slice(15, 17)
          let randomNumber = fullInvoiceNumber.slice(17, 21)
          let salesAmount = Number(parseInt(fullInvoiceNumber.slice(21, 29), 16))
          let taxAmount = Number(parseInt(fullInvoiceNumber.slice(29, 37), 16))
          let buyerIdentifier = fullInvoiceNumber.slice(37, 45)
          let sellerIdentifier = fullInvoiceNumber.slice(45, 53)
          let aesKey = fullInvoiceNumber.slice(53, 77)
          let invoiceItems = fullInvoiceNumber.slice(77, fullInvoiceNumber.length).split(":")
          invoiceItems.shift()
          invoiceItems.shift()
          let totalItem = Number(invoiceItems.shift())
          invoiceItems.shift()
          let encode = Number(invoiceItems.shift())
          let aryItems = R.splitEvery(3, invoiceItems)

          let productAry = aryItems.map((item) => {
            if (item[0] !== "**") {
              let obj = { productName: item[0].replace(/^\*+/, ''), productQty: Number(item[1]), productPrice: Number(item[2].replace(/\**$/, '')) }
              return obj
            }
          }).filter((item) => (item !== undefined && item.productPrice !== 0 && item.productPrice !== NaN && item.productName !== NaN))

          document.querySelector('#transaction_invoice_num').value = number
          document.querySelector('#transaction_amount').value = taxAmount
          document.querySelector('#transaction_invoice_date').value = `${Number(Year) + 1911}-${Month}-${Day}`

          productAry.map((item, idx) => {
            let temp = `
          <div class="nested-fields">
             <div class="form-group">
                <input type="hidden" name="transaction[transaction_items_attributes][${idx + 1}][id]" id="transaction_transaction_items_attributes_${idx + 1}_id" />
                <label for="transaction_transaction_items_attributes_${idx + 1}_title">品項名稱</label>
                <input class="form-control" type="text" name="transaction[transaction_items_attributes][${idx + 1}][title]" id="transaction_transaction_items_attributes_${idx + 1}_title" />
              </div>
              <div class="form-group">
                <label for="transaction_transaction_items_attributes_${idx + 1}_quantity">品項數量</label>
                <input class="form-control" type="text" name="transaction[transaction_items_attributes][${idx + 1}][quantity]" id="transaction_transaction_items_attributes_${idx + 1}_quantity" />
              </div>
              <div class="form-group">
                <label for="transaction_transaction_items_attributes_${idx + 1}_price">品項單價</label>
                <input class="form-control" type="text" name="transaction[transaction_items_attributes][${idx + 1}][price]" id="transaction_transaction_items_attributes_${idx + 1}_price" />
              </div>
              <div class="form-group">
                <label for="transaction_transaction_items_attributes_${idx + 1}_total">品項總價</label>
                <input class="form-control" type="text" name="transaction[transaction_items_attributes][${idx + 1}][total]" id="transaction_transaction_items_attributes_${idx + 1}_total" />
              </div>
              <input value="false" type="hidden" name="transaction[transaction_items_attributes][${idx + 1}][_destroy]" id="transaction_transaction_items_attributes_${idx + 1}__destroy" /><a class="remove_fields dynamic" href="#">remove item</a>
            </div>
          `

            document.querySelector(`#transaction_transaction_items_attributes_${idx}_title`).value = item.productName
            document.querySelector(`#transaction_transaction_items_attributes_${idx}_quantity`).value = item.productQty
            document.querySelector(`#transaction_transaction_items_attributes_${idx}_price`).value = item.productPrice
            document.querySelector(`#transaction_transaction_items_attributes_${idx}_total`).value = item.productQty * item.productPrice

            if (productAry.length > 1 && idx < productAry.length - 1) document.querySelector('#add-item-btn').insertAdjacentHTML('beforebegin', temp)
            this.isScanned = true
            this.clicked = false
          })
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

