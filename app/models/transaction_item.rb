class TransactionItem < ApplicationRecord
  # validations
  validates :title, presence: true
  validates :quantity, :price, :total, numericality: { greater_than: 0 }
  
  # Relationships
  belongs_to :transaction_record, class_name: "Transaction", foreign_key: 'transaction_id'
  # 讓transaction_record 指定找Model "Transaction" (因預設會找TransactionRecord)，並指定外鍵為"transaction_id"
end 