class MembershipsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :create, :create_for_guest, :unsubscribe_from_email]
  before_filter :find_challenge, except: [:unsubscribe_from_email]
  before_filter :find_membership, only: [:update]
  before_filter :find_membership_from_hash, only: [:unsubscribe_from_email]
  before_filter :require_challenge_owner, only: [:index]

  respond_to :html, :json, :js

  def index
    @memberships = @challenge.memberships
  end

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @membership = @challenge.memberships.find_by_user_id(current_user.id)
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
    redirect_to @challenge
  end

  # This is to let someone sign up for a challenge with only their email
#  def create_for_guest
#    @membership_form = MembershipForm.new(params[:membership_form])
#    @membership_form.challenge = @challenge
#    if @membership_form.valid? && @membership_form.subscribe
#      flash[:notice] = "Thank you for joining. check your email inbox for more details!"
#      redirect_to @challenge
#    else
#      flash[:error] = @membership_form.errors.full_messages.to_sentence
#      redirect_to @challenge
#    end
#  end

  def unsubscribe_from_email
    if @membership
      @hash = params[:hash]
      @user = @membership.user
      sign_in @user
    else
      flash[:error] = "This unsubscribe link doesn't exist"
    end
    render layout: 'from_email'
  end

  def destroy
    @membership = (params[:id].blank?)? find_membership_from_hash : current_user.memberships.find(params[:id])
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
    @membership = @challenge.memberships.find(params[:id])
    redirect_to @challenge if @membership.nil?
  end

  def find_membership_from_hash
    hashids = HashidsGenerator.instance
    membership_id = hashids.decrypt(params[:hash])
    @membership = Membership.find_by_id(membership_id)
  end

  def require_challenge_owner
    redirect_to root_url if @challenge.owner != current_user
  end

end
