class Member::MembershipsController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:unsubscribe, :destroy]

  before_filter :authenticate_user!

  respond_to :html, :json, :js

  def show
    respond_with(membership)
  end

  def unsubscribe
    membership
  end

  def update
    if membership.update_attributes(membership_update_params)
      flash[:notice] = "You have successfully updated your challenge settings."
    end
    challenge = membership.challenge
    redirect_to member_challenge_path(challenge)
  end

  def create
    if challenge.joinable
      @membership = challenge.memberships.build(params[:membership])
      @membership.user = current_user if current_user
      if @membership.save
        MembershipCompletion.new(@membership)
        flash[:notice] = "Thank you for joining!"
      else
        flash[:error] = @membership.errors.full_messages.to_sentence
      end
      redirect_to [:member, challenge]
    else
      flash[:notice] = "Sorry, this challenge has been closed by the owner."
      redirect_to challenge
    end
  end

  def join_group
    membership.group_id = params[:group_id] if params[:group_id]
    if membership.save
      flash[:notice] = "You have successfully joined this group"
    end
    redirect_to challenge
  end

  def destroy
    challenge = membership.challenge
    membership.destroy
    challenge.update_stats
    flash[:notice] = "You have been successfully unsubscribed from this challenge"
    redirect_to challenge
  end

  def sign_up_via_email
    flash[:notice] = SignUpViaEmail.new(params[:invite_email], challenge).flash
    redirect_to challenge
  end

  private

  def email_validated?
    param_email = params[:invite_email]
    email = EmailValidator.new(param_email)
    email.valid?
  end

  def existing_user
    @user ||= User.find_by_email(params[:invite_email])
  end

  def membership_update_params
    params.require(:membership).permit(:bible_version)
  end

  def challenge
    @challenge ||= Challenge.friendly.find(params[:challenge_id])
  end

  def membership
    @membership ||= current_user.memberships.find(params[:id])
  end

  def require_challenge_owner
    redirect_to root_url if challenge.owner != current_user
  end
end
