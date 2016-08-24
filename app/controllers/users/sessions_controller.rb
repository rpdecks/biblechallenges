class Users::SessionsController < Devise::SessionsController
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

  def user_already_has_a_google_account
    @user && @user.provider == "google_oauth2"
  end
end
