class MembershipsController < ApplicationController

  def index
    @memberships = current_user.memberships
  end

  def show
    @membership = Membership.find(params[:id])
  end

  def update
    @challenge = Challenge.find_by_subdomain(request.subdomain)
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      redirect_to membership_path(@membership)
    else
      render :action => "edit"
    end
  end

  def new
    @challenge = Challenge.find_by_subdomain(request.subdomain)
    @membership = Membership.new
  end

  def edit
    @challenge = Challenge.find_by_subdomain(request.subdomain)
    @membership = Membership.find(params[:id])
  end

  def create
    @membership = Membership.new(params[:membership])
    if @membership.save
      flash[:notice] = "Thank you for joining!  We just need a few more details:"
      redirect_to edit_membership_path(@membership)
    else
      @challenge = Challenge.find_by_subdomain(request.subdomain)
      render :action => 'new'
    end

  end
end
