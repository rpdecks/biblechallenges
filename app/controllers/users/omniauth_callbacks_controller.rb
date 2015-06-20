class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    #if @user.existing_user?
    #  sign_in_and_redirect @user
    #else
    #  redirect_to new_user_password_path @user
    #end

    if @user.persisted?
      if @user.existing_user?
        sign_in_and_redirect @user
        if is_navigational_format?
          set_flash_message(:notice, :success, :kind => "Facebook")
        end
      else
        sign_in @user
        redirect_to finish_signup_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
