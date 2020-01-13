class Category < ApplicationRecord
  # relationship
  has_many :relations
  has_many :transaction_items, through: 'relations'
end
