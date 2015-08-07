class Users::RegistrationsController < Devise::RegistrationsController
  after_action :complete_user, only: :create

  def finish_signup
    if request.patch? && params[:user]
      @user = User.find(params[:user][:id])
      if @user.update(user_params)
        @user.skip_reconfirmation! if @user.respond_to?(:skip_confirmation)
        flash[:notice] = "You have signed up successfully"
        if params[:challenge_id].present? #Joining new user to the challenge and redirect to the challenge
          ch_id = params[:challenge_id]
          @challenge = Challenge.find(ch_id)
          membership = @challenge.join_new_member(@user)
          MembershipCompletion.new(membership)
          @challenge.update_stats
          sign_in @user
          redirect_to (member_challenges_path)
        else
          sign_in_and_redirect(@user)
        end
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
      end
    end
  end

  # POST /resource
  def create
    super
     if self.params[:challenge_id].present? #If challenge id is set, that means we need to add the user being created to the challenge and redirect to the challenge
       ch_id = self.params[:challenge_id]
       challenge = Challenge.find(ch_id)
       email = self.params[:user][:email]
       @user = User.where(email: email).first
       membership = challenge.join_new_member(@user)
       MembershipCompletion.new(membership)
       challenge.update_stats
     end
  end

  def after_sign_up_path_for(resource)
    if self.params[:challenge_id].present?
      member_challenges_path
    else
      root_path
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
