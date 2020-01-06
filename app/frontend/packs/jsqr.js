const jsQR = require("jsqr")
const R = require('ramda')

document.addEventListener("turbolinks:load", () => {
   video = document.createElement("video")
   canvasElement = document.getElementById("scanner")
   canvas = canvasElement.getContext("2d")

  document.querySelector('#startButton').addEventListener('click', (evt) => {
    evt.preventDefault()
    scanedQRCode = []
    pause = false
    navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function (stream) {
      window.stream = stream
      video.srcObject = stream
      video.setAttribute("playsinline", true)
      video.play()
      canvasElement.hidden = false
      requestAnimationFrame(tick)
    })
  })
})


function tick() {
  if (video.readyState === video.HAVE_ENOUGH_DATA) {

    canvasElement.height = video.videoHeight
    canvasElement.width = video.videoWidth
    canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height)
    let imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height)
    let code = jsQR(imageData.data, imageData.width, imageData.height, {
      inversionAttempts: "dontInvert",
    })

    console.log(code)

    if (code) {
      drawLine(code.location.topLeftCorner, code.location.topRightCorner, "#FF3B58")
      drawLine(code.location.topRightCorner, code.location.bottomRightCorner, "#FF3B58")
      drawLine(code.location.bottomRightCorner, code.location.bottomLeftCorner, "#FF3B58")
      drawLine(code.location.bottomLeftCorner, code.location.topLeftCorner, "#FF3B58")
      insertQRCodeData(code.data)
    }
  }
  if (pause) return
  requestAnimationFrame(tick)
}

function insertQRCodeData(codeData) {
  scanedQRCode.push(codeData)
  let invoiceQRCode =  scanedQRCode.filter(unique).sort().reverse()

  if (/^[A-Z]{2}\d{8}/.test(invoiceQRCode[0]) && invoiceQRCode.length === 2) {
    let fullInvoiceNumber = invoiceQRCode.join('')
    let number = fullInvoiceNumber.slice(0, 10)
    let dateYear = fullInvoiceNumber.slice(10, 13)
    let dateMonth = fullInvoiceNumber.slice(13, 15)
    let dateDay = fullInvoiceNumber.slice(15, 17)
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
    let productAry = aryItems.map((item) => ({productName: item[0], productQty: Number(parseInt(item[1], 10)), productPrice: Number(parseInt(item[2], 10))}))

    document.querySelector('#transaction_invoice_num').value = number
    document.querySelector('#transaction_amount').value = taxAmount

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
    })
    window.stream.getTracks().forEach(track => track.stop())
    canvasElement.hidden = true
    scanedQRCode = []
    pause = true
  }
}

function unique(value, index, self) {
  return self.indexOf(value) === index
}

function drawLine(begin, end, color) {
  canvas.beginPath()
  canvas.moveTo(begin.x, begin.y)
  canvas.lineTo(end.x, end.y)
  canvas.lineWidth = 4
  canvas.strokeStyle = color
  canvas.stroke()
}
