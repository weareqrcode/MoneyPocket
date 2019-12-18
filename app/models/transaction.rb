class Transaction < ApplicationRecord
  # validations
  
  # Relationships
  belongs_to :user
  has_many :transaction_items
  accepts_nested_attributes_for :transaction_items, allow_destroy: true, reject_if: :all_blank, validate: false
  # reject_if原型 --> reject_if: lambda {|attributes| attributes['invoice_num', 'invoice_photo', 'amount', 'status'].blank?}
end
