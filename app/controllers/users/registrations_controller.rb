class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user, event: :authentication # devise
      log_in @user # custom auth
      remember(@user) # custom auth
      render json: { current_user: @user, auth_token: @user.remember_token }
    else
      render json: { error: @user.errors.full_messages.join(', ') }
    end
  end

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
  end
end
