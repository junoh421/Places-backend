class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :friendships
  has_many :friends, :through => :friendships, :source => :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # validates :username, format: { with: /\A[\w-]+\z/, message: "May only contain letters, numbers, dashes, and underscores."}
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    # where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.facebook_photo = auth.info.image
    end
  end


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['oauth_data'] && session['oauth_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

end

# curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{ "user": { "first_name": "John", "last_name": "Doe", "username": "test", "email": "test@test.com", "password": "password", "password_confirmation": "password" }}' localhost:3000/users
