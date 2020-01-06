class Income < ApplicationRecord
  # validations
  validates :title, :description, presence: true
  validates :total, numericality: { greater_than: 0 }

  # Relationship
  belongs_to :user
end
