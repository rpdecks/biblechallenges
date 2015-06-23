class Users::RegistrationsController < Devise::RegistrationsController
  after_action :complete_user, only: :create

  def finish_signup
    if request.patch? && params[:user]
      @user = User.find(params[:user][:id])
      if @user.update(user_params)
        @user.skip_reconfirmation! if @user.respond_to?(:skip_confirmation)
        flash[:notice] = "You have signed up succesfully"
        sign_in_and_redirect(@user)
      end
    end
  end

  private

  def complete_user
    UserCompletion.new(@user)
  end

# leaving this boilerplate below because it is rather helpful

# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)

  private

  def user_params
    accessible = [ :name, :email ]
    unless params[:user][:password].blank?
      accessible << [ :password, :password_confirmation ]
    end
    params.require(:user).permit(accessible)
  end
end
