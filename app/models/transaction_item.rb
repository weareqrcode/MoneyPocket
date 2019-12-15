class TransactionItem < ApplicationRecord
  # Relationships
  belongs_to :transaction_records, class_name: "Transaction", foreign_key: :transaction_id
  # 讓transaction_record 指定找Model "Transaction"，並指定外鍵為"transaction_id"
end
