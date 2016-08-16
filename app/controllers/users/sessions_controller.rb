class Users::SessionsController < Devise::SessionsController
  def create
    user = User.where(email: user_params[:email]).first
    if user
      if user.provider == "facebook"
        redirect_to new_user_registration_path
        flash[:notice] = "That account appears to be a Facebook Account without a password. Try using the Log in with Facebook button."
      elsif user.provider == "google_oauth2"
        redirect_to new_user_registration_path
        flash[:notice] = "That account appears to be a Google Account without a password. Try using the Log in with Google button."
      else
        super
      end
    end
  end

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

  def after_sign_out_path_for(resource)
    session[:previous_url] = ""
  end

  def user_params
    params[:user]
  end
end
