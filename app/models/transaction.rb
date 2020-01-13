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












  def go1
    if Date.current.month % 2 == 0
      (Date.current - 2.months).end_of_month
    elsif Date.current.day > 25 
      (Date.current - 1.months).end_of_month
    else
      (Date.current - 3.months).end_of_month
    end
  end


  def star1
    if Date.current.month % 2 == 0
      (Date.current - 4.months).end_of_month+1.day
    elsif Date.current.day > 25 
      (Date.current - 3.months).end_of_month+1.day
    else
      (Date.current - 5.months).end_of_month+1.day
    end
  end

def go2
  if Date.current.month % 2 == 0
    (Date.current - 4.months).end_of_month
  elsif Date.current.day > 25 
    (Date.current - 3.months).end_of_month
  else
    (Date.current - 5.months).end_of_month
  end
end

def star2
  if Date.current.month % 2 == 0
    (Date.current - 6.months).end_of_month+1.day
  elsif Date.current.day > 25 
    (Date.current - 5.months).end_of_month+1.day
  else
    (Date.current - 7.months).end_of_month+1.day
  end
end


end
