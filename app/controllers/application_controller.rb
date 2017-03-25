class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :username])
  end
end
