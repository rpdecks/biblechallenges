class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    omniauth("facebook")
  end

  def google_oauth2
    omniauth("google_oauth2")
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
end
