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
      if @user.existing_user?
        sign_in @user
        redirect_to (member_challenges_path)
        #sign_in_and_redirect @user
        if is_navigational_format?
          set_flash_message(:notice, :success, kind: provider)
        end
      else
        UserCompletion.new(@user)
        sign_in @user
        if request.env["omniauth.params"].present? #If challenge id is set, we need to pass it finish_signup
          ch_id = request.env["omniauth.params"]["challenge_id"]
          redirect_to finish_signup_path(challenge_id: ch_id)
        else
          redirect_to finish_signup_path
        end
      end
    else
      # store omniauth data into session
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
