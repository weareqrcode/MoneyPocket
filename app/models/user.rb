class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :google_oauth2]

  # validations
  validates :email, presence: true

  # Relationships
  has_many :transactions
  has_many :transaction_items, through: 'transactions', source: 'transaction_items'
  has_many :incomes

  # 第三方登入
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:google_token => access_token.credentials.token, :google_uid => access_token.uid ).first    
    if user
      return user
    else
      existing_user = User.where(:email => data["email"]).first
      if  existing_user
        existing_user.google_uid = access_token.uid
        existing_user.google_token = access_token.credentials.token
        existing_user.save!
        return existing_user
      else
        user = User.create(
            name: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20],
            google_token: access_token.credentials.token,
            google_uid: access_token.uid
          )
      end
    end
  end

  def self.from_omniauth(auth)
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end
    existing_user = User.find_by_email( auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
    user.save!
    return user
  end

end
