class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  validates :username, format: { with: /\A[\w-]+\z/, message: "May only contain letters, numbers, dashes, and underscores."}
  validates :email, :username, presence: true, uniqueness: true

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
      if data = session["oauth_data"] && session["oauth_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
