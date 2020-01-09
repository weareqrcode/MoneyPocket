class TransactionItem < ApplicationRecord
  # validations
  validates :title, presence: true
  validates :quantity, :price, :total, numericality: { greater_than: 0 }
  
  # Relationships
  belongs_to :transaction_record, class_name: "Transaction", foreign_key: 'transaction_id'
end 