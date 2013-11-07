class MembershipsController < ApplicationController

  def index
    @memberships = current_user.memberships
  end

  def show
    @membership = Membership.find(params[:id])
  end
end
