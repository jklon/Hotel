class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def user_params_sane? user_params
    return if user_params[:auth_token]
    unless user_params[:number]
      render json: {error: "no customer number"}, status: :unprocessable_entity
      return
    end

    unless user_params[:number].length == 10
      render json: {error: "customer number is wrong. Enter 10 digit mobile number (without leading 0 or +91)"}, status: :unprocessable_entity
      return
    end

    unless user_params[:first_name]
      render json: {error: "no customer name"}, status: :unprocessable_entity
      return
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
