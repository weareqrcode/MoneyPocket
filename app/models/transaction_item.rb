class TransactionItem < ApplicationRecord
  # validations
  validates :title, presence: true
  validates :quantity, :price, :total, numericality: { greater_than: 0 }
  
  # Relationships
  belongs_to :transaction_record, class_name: "Transaction", foreign_key: 'transaction_id'
  has_many :relations, dependent: :destroy
  has_many :categories, through: 'relations', source: 'categories'
  
  def category_list
    categories.map(&:tag_name).join(', ')
  end

  def category_list=(tag_names)
    self.categories = tag_names.split(',').map do |item|
      Category.where(tag_name: item.strip).first_or_create!
    end
  end

  def category_items
    categories.map(&:tag_name).join(',')
  end

  def category_items=(tag_names)
    tags = tag_names.split(',')
    self.categories = tags.map do |tag|
      Category.where(tag_name: tag.strip).first_or_create!
    end
  end
end 