class Users::SessionsController < Devise::SessionsController
  def create
    @user = User.where(email: user_params[:email]).first

    if user_already_has_a_facebook_account
      redirect_to new_user_registration_path
      flash[:notice] = "That account appears to be a Facebook Account. Try using the Log in with Facebook button."
    elsif user_already_has_a_google_account
      redirect_to new_user_registration_path
      flash[:notice] = "That account appears to be a Google Account. Try using the Log in with Google button."
    else
      super
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

  def user_already_has_a_facebook_account
    @user && @user.provider == "facebook"
  end

  def user_already_has_a_google_account
    @user && @user.provider == "google_oauth2"
  end
end
