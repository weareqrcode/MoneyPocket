class Transaction < ApplicationRecord
  include AASM

  # Relationships
  belongs_to :user
  has_many :transaction_items, inverse_of: :transaction_record, dependent: :destroy
  accepts_nested_attributes_for :transaction_items, :allow_destroy => true

  scope :with_time, -> (time) { time.present? ? where('created_at > ?', time) : all }

  # photo upload
  has_one_attached :invoice_photo

  # 狀態機
  enum status: { pending: 0, missed: 1, won: 2 }

  aasm column: 'status', no_direct_assignment: true do
    state :pending, initial: true
    state :missed, :won

    event :miss do
      transitions from: :pending, to: :missed
    end

    event :win do
      transitions from: :pending, to: :won
    end
  end
end