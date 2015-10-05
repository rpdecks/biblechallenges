class Creator::MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_action :validate_ownership, only: [:edit, :update]

  #respond_to :html, :json, :js

  def update
    @membership = Membership.find(params[:id])
    @group = Group.find(params[:membership][:group_id])
    @challenge = Challenge.find(params[:membership][:challenge_id])

    if @challenge.memberships.include?(@membership) && @membership.update_attributes(group_id: @group.id)
      flash[:notice] = "You have successfully changed this member's group"
      redirect_to creator_challenge_path(@challenge.id)
    else
      flash[:notice] = "Could not update group settings"
      redirect_to edit_creator_membership_path
    end
  end

  def edit
    @challenge = Challenge.friendly.find(params[:id])
    @membership = Membership.find(params[:format])
    @all_challenge_groups = @challenge.groups

  end
end
