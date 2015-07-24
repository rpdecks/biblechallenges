class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

private
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

#  def default_url_options(options = {})
#    {locale: I18n.locale}
#  end

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
