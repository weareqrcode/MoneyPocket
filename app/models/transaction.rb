class Transaction < ApplicationRecord
  # validations

  #photo upload
  has_one_attached :invoice_photo
  # Relationships
  belongs_to :user
  has_many :transaction_items, inverse_of: :transaction_record, dependent: :destroy
  accepts_nested_attributes_for :transaction_items, :allow_destroy => true
  # reject_if原型 --> reject_if: lambda {|attributes| attributes['invoice_num', 'invoice_photo', 'amount', 'status'].blank?}
end
