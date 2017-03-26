class Users::SessionsController < Devise::SessionsController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
