class Transaction < ApplicationRecord
  include AASM

  enum status: { pending: 0, missed: 1, won: 2 }
  #photo upload
  has_one_attached :invoice_photo
  # Relationships
  belongs_to :user
  has_many :transaction_items, inverse_of: :transaction_record, dependent: :destroy
  accepts_nested_attributes_for :transaction_items, :allow_destroy => true
  # reject_if原型 --> reject_if: lambda {|attributes| attributes['invoice_num', 'invoice_photo', 'amount', 'status'].blank?}

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
