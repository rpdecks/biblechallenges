class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath

      # to see if the time is recent enough
      #session[:last_request_time] = Time.now.utc.to_i
    end
  end

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

  #todo: should this be in sessions_controller?
  def after_sign_in_path_for(resource)
    if session[:previous_url] == root_path
      if resource.is_a?(User) && resource.challenges.present?
        member_challenges_path
      else
        root_path
      end
    else
      session[:previous_url] || root_path
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
