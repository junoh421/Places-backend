class Api::V1::UsersController < ApiController

  def show
    user = User.find_by(username: params[:data][:username])

    render json: {
      username: user.username,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }, status: :ok
  end
end
