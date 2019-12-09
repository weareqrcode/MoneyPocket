class Transaction < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :transaction_items
end
