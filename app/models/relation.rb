class Relation < ApplicationRecord
  belongs_to :category
  belongs_to :transaction_item
end
