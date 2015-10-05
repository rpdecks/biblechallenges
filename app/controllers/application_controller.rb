class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        #request.path != "/users/password/new" &&
        #request.path != "/users/password/edit" &&
        #request.path != "/users/confirmation" &&
        #request.path != "/users/sign_out" &&
        request.path != "/users/auth/facebook/callback" &&
        request.path != "/users/auth/google_oauth2/callback" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath

      # to see if the time is recent enough
      #session[:last_request_time] = Time.now.utc.to_i
    end
  end

  def render_nothing(status = :ok)
    render json: {}, status: status
  end

  def test_exception_notifier
    raise "This is only a test :) "
  end

  def validate_ownership
    if params[:action] == "update" 
      challenge_id = params[:membership][:challenge_id]
      @challenge = Challenge.find(challenge_id)
    elsif params[:controller] == "creator/groups"
      challenge_id = params[:challenge_id]
      @challenge = Challenge.find(challenge_id)
    else
      @challenge = Challenge.friendly.find(params[:id])
    end

    unless current_user == @challenge.owner
      flash[:notice] = "Access denied"
      redirect_to member_challenges_path
    end
  end

  protected

  # put these in registrations controller?
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
