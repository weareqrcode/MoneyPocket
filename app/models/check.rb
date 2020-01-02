class Check < ApplicationRecord
  has_one :transaction_record, class_name: "Transaction", foreign_key: 'transaction_id'
end
