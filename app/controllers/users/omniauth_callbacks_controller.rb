class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user_email

  def facebook
    omniauth("facebook")
    if user_already_has_a_google_account_with_the_same_email
      flash[:notice] = "It looks like you already have a Google account with the same email. Try using the Log in with Google button."
      return
    end
  end

  def google_oauth2
    omniauth("google_oauth2")
    if user_already_has_a_facebook_account_with_the_same_email
      flash[:notice] = "It looks like you already have a Facebook account with the same email. Try using the Log in with Facebook button."
      return
    end
  end

  def omniauth(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end

  def set_user_email
    @user_email = request.env["omniauth.auth"]["info"]["email"]
  end

  def user_already_has_a_google_account_with_the_same_email
    existing_user = User.find_by(email: @user_email)
    existing_user && existing_user.provider == "google_oauth2"
  end

  def user_already_has_a_facebook_account_with_the_same_email
    existing_user = User.find_by(email: @user_email)
    existing_user && existing_user.provider == "facebook"
  end
end
