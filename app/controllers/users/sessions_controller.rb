class Users::SessionsController < Devise::SessionsController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    remember(@user)
  end

  def destroy
    sign_out
    render json: { message: 'Logged out.' }, status: :ok
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
