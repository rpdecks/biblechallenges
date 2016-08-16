class Users::RegistrationsController < Devise::RegistrationsController
  after_action :complete_user, only: :create

  # POST /resource
  def create
    super
    # If challenge id is set, that means we need to add the user being created to the challenge and redirect to the challenge
    if self.params[:challenge_id].present?
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
    session[:previous_url]
  end

  private

  def complete_user
    UserCompletion.new(@user)
  end

  private

  def user_params
    accessible = [ :name, :email, :reading_notify, :message_notify, :comment_notify ]
    unless params[:user][:password].blank?
      accessible << [ :password, :password_confirmation ]
    end
    params.require(:user).permit(accessible)
  end
end
