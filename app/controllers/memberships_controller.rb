class MembershipsController < ApplicationController

  before_filter :find_challenge, except: [:index, :show]

  def index
    @memberships = current_user.memberships
  end

  def show
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      redirect_to membership_path(@membership)
    else
      render action: 'edit'
    end
  end

  def new
    @membership = Membership.new
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def create
    @membership = Membership.new(params[:membership])
    if @membership.save
      flash[:notice] = "Thank you for joining!  We just need a few more details:"
      redirect_to edit_membership_path(@membership)
    else
      render action: 'new'
    end
  end

  private

  def find_challenge
    @challenge = Challenge.find_by_subdomain(request.subdomain)
    redirect_to root_url(subdomain:false) if @challenge.nil?
  end


end
