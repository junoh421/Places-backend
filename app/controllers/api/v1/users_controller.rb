class Api::V1::UsersController < ApplicationController
  def show
    # user = User.find_by(username: params[:data][:username])
    #

    @user = User.find(params[:id])

    if @user.authenticated?(user_token)
      render json: {
        username: @user.username,
        first_name: @user.first_name,
        last_name: @user.last_name,
        email: @user.email
      }, status: :ok
    else
      render json: { msg: 'Unauthorized.' }, status: :unauthorized
    end
  end

  private

  def user_token
    request.headers['X-AUTH-TOKEN'].presence
  end
end
