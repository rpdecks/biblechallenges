class MembershipsController < ApplicationController

  def index
    @memberships = current_user.memberships
  end

  def show
    @membership = Membership.find(params[:id])
  end

  def new
    @challenge = Challenge.find_by_subdomain(request.subdomain)
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(params[:membership])
    if @membership.save
      redirect_to membership_path(@membership)
    else
      @challenge = Challenge.find_by_subdomain(request.subdomain)
      render :action => 'new'
    end

  end
end
