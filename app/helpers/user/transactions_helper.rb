module User::TransactionsHelper
    def invoice_photo_tag(transaction, width: 300, height: 300, fake_img: false)
    if fake_img
      if transaction.invoice_photo.attached?
        generate_invoice_photo(transaction, width, height)
      else
        image_tag "https://fakeimg.pl/#{width}x#{height}/?text=photo"
      end
    else
      generate_invoice_photo(transaction, width, height) if transaction.invoice_photo.attached?
    end
  end

private
  def generate_invoice_photo(transaction, width, height)
    image_tag transaction.invoice_photo.variant(resize_to_limit: [width, height])
  end
end
