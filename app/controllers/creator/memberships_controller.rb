class Creator::MembershipsController < ApplicationController

  before_filter :authenticate_user!

  #respond_to :html, :json, :js

  def update
    @membership = Membership.find(params[:id])
    @group = Group.find(params[:group_id])
    @challenge = Challenge.find(params[:challenge_id])

    if @membership.update_attributes(group_id: @group.id)
      flash[:notice] = "You have successfully changed this member's group"
      redirect_to creator_challenge_path(@challenge.id)
    else
      flash[:notice] = "Could not update group settings"
      redirect_to edit_creator_membership_path
    end
  end

  def edit
    binding.pry
  end

  def membership
    @membership ||= current_user.memberships.find(params[:id])
  end
end
