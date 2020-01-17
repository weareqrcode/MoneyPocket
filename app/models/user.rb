class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # validations
  validates :email, presence: true

  # Relationships
  has_many :transactions
  has_many :transaction_items, through: 'transactions', source: 'transaction_items'
  has_many :incomes

  # 第三方登入
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
