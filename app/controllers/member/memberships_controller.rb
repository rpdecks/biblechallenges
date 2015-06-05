class Member::MembershipsController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:unsubscribe, :destroy]

  before_filter :authenticate_user!

  respond_to :html, :json, :js

  def index
    @memberships = challenge.memberships
  end

  def show
    respond_with(membership)
  end

  def unsubscribe
    membership
  end

  def update
    if membership.update_attributes(params[:membership])
      flash[:notice] = "You have successfully updated your challenge settings."
      redirect_to challenge_path(membership.challenge)
    else
      render action: 'show'
    end
  end

  def create
    @membership = challenge.memberships.build(params[:membership])
    @membership.user = current_user if current_user
    if @membership.save
      flash[:notice] = "Thank you for joining!" 
    else
      flash[:error] = @membership.errors.full_messages.to_sentence
    end
    redirect_to [:member, challenge]
  end

  def join_group
    membership.group_id = params[:group_id] if params[:group_id]
    membership.save
    redirect_to challenge
  end

  def destroy
    challenge = membership.challenge
    membership.destroy
    flash[:notice] = "You have been successfully unsubscribed from this challenge"
    redirect_to challenge
  end

  private

  def challenge
    @challenge ||= Challenge.find_by_id(params[:challenge_id])
  end

  def membership
    @membership ||= current_user.memberships.find(params[:id])
  end

  def require_challenge_owner
    redirect_to root_url if challenge.owner != current_user
  end

end
