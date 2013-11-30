class MembershipsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :create, :create_for_guest, :unsubscribe_from_email]
  before_filter :find_challenge
  before_filter :require_challenge_owner, only: [:index]

  def index
    @memberships = @challenge.memberships
  end

  def show
    if current_user
      unless @membership = @challenge.membership_for(current_user)
        redirect_to root_url(subdomain: @challenge.subdomain)
      end
    else
      redirect_to root_url(subdomain: @challenge.subdomain)
    end
  end

  def update
    @membership = @challenge.memberships.find(params[:id])
    if @membership.update_attributes(params[:membership])
      redirect_to membership_path(@membership)
    else
      render action: 'edit'
    end
  end

  def edit
    @membership = @challenge.memberships.find(params[:id])
  end

  def create
    @membership = @challenge.memberships.build(params[:membership])
    @membership.user = current_user if current_user
    if @membership.save
      flash[:notice] = "Thank you for joining!"
      redirect_to my_membership_path
    else
      redirect_to root_url(subdomain: @challenge.subdomain)
    end
  end

  def create_for_guest
    @membership_form = MembershipForm.new(params[:membership_form])
    @membership_form.challenge = @challenge
    if @membership_form.valid? && @membership_form.subscribe
      flash[:notice] = "Thank you for joining!"
      redirect_to root_url(subdomain: @challenge.subdomain)
    else
      flash[:error] = @membership_form.errors.full_messages.to_sentence
      redirect_to root_url(subdomain: @challenge.subdomain)
    end
  end

  def unsubscribe_from_email
    render_nothing
  end

  def destroy
    @membership = current_user.memberships.find(params[:id])
    @membership.destroy
    flash[:notice] = "You have been successfully unsubscribed from this challenge"
    redirect_to root_url(subdomain:@challenge.subdomain)
  end

  private

  def find_challenge
    @challenge = Challenge.find_by_subdomain(request.subdomain) || Challenge.find_by_id(params[:challenge_id])
    redirect_to root_url(subdomain:false) if @challenge.nil?
  end

  def require_challenge_owner
    redirect_to root_url(subdomain:false) if @challenge.owner != current_user
  end

end
