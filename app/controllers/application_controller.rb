class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :store_location

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.challenges.present?
      member_challenges_path
    else
      session[:previous_url] || root_path
    end
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/auth/facebook/callback" &&
        request.path != "/users/auth/google_oauth2/callback" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

  def test_exception_notifier
    raise "This is only a test :) "
  end

  def validate_challenge_ownership
    @challenge = Challenge.friendly.find(params[:challenge_id])

    unless current_user == @challenge.owner
      flash[:notice] = "Access denied"
      redirect_to member_challenges_path
    end
  end

  def current_user
    @current_user ||= super || Guest.new
  end

  def user_signed_in?
    super && !current_user.is_a?(Guest)
  end

  protected

  # put these in registrations controller?
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      update_params = registration_params << :current_password
      devise_parameter_sanitizer.permit(:sign_up, keys: update_params)
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    end
  end
end
