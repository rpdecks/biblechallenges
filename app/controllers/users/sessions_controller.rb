class Users::SessionsController < Devise::SessionsController
  #def after_sign_in_path_for(resource)
  #  account_path
  #end

  def after_sign_out_path_for(resource)
    session[:previous_url] = ""
  end

  # why protect something?
  # protected :after_sign_in_path_for
end
