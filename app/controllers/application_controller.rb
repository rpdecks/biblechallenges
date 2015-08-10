class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.challenges.present?
      member_challenges_path
    else
      root_path
    end
  end

  def test_exception_notifier
    raise "This is only a test :) "
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
