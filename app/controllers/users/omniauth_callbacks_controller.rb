class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      @user.update_attributes(provider: request.env['omniauth.auth']['provider'], facebook_photo: request.env['omniauth.auth']['info']['image'])
      @user.increment! :sign_in_count
      @user.touch :last_sign_in_at
      sign_in @user, event: :authentication #this will throw if @user is not activated
      render json: { msg: 'Sucessfully authenticated.' }
    else
      session['oauth_data'] = request.env['omniauth.auth']
      render json: { msg: 'Saved Oauth data to session.' }
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def failure
    render json: { msg: 'Oauth authentication failed.' }
  end
end

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
