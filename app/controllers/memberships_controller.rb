class MembershipsController < ApplicationController

  before_filter :find_challenge
  before_filter :require_challenge_owner, only: [:index]

  def index
    @memberships = @challenge.memberships
  end

  def show
    @membership = if current_user
      @challenge.membership_for(current_user) || @challenge.memberships.build
    else
      @challenge.memberships.build
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
    @membership =@challenge.memberships.find(params[:id])
  end

  def create
    @membership = @challenge.memberships.build(params[:membership])
    if @membership.save
      flash[:notice] = "Thank you for joining!  We just need a few more details:"
      redirect_to edit_membership_path(@membership)
    else
      render action: 'new'
    end
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
