class Member::MembershipsController < ApplicationController

  before_filter :authenticate_user!
  
  before_filter :find_challenge, except: [:destroy, :show, :find_challenge, :unsubscribe_from_email]
  before_filter :find_membership, only: [:update, :join_group, :destroy, :show]

  respond_to :html, :json, :js

  def index
    @memberships = @challenge.memberships
  end

  def show
    respond_with(@membership)
  end

  def update
    if @membership.update_attributes(params[:membership])
      flash[:notice] = "You have successfully updated your challenge settings."
      redirect_to challenge_path(@membership.challenge)
    else
      render action: 'show'
    end
  end

  def create
    @membership = @challenge.memberships.build(params[:membership])
    @membership.user = current_user if current_user
    if @membership.save
      flash[:notice] = "Thank you for joining!" 
    else
      flash[:error] = @membership.errors.full_messages.to_sentence
    end
    redirect_to [:member, @challenge]
  end

  def join_group
    @membership.group_id = params[:group_id] if params[:group_id]
    @membership.save
    redirect_to @challenge
  end

  def unsubscribe_from_email
    if @membership = Membership.find_by_id(params[:id])
      @user = @membership.user
      sign_in @user
    else
      flash[:error] = "This unsubscribe link doesn't exist"
    end
    render layout: 'from_email'
  end

  def destroy
    challenge = @membership.challenge
    @membership.destroy
    flash[:notice] = "You have been successfully unsubscribed from this challenge"
    redirect_to challenge
  end

  private

  def find_challenge
    @challenge = Challenge.find_by_id(params[:challenge_id])
    redirect_to root_url if @challenge.nil?
  end

  def find_membership
    @membership = current_user.memberships.find(params[:id])
    redirect_to @challenge if @membership.nil?
  end

  def require_challenge_owner
    redirect_to root_url if @challenge.owner != current_user
  end

end
