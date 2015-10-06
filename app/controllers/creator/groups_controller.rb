class Creator::GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :validate_challenge_ownership, only: [:edit, :new]

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.new
  end

  def create
    @challenge = Challenge.friendly.find(params[:challenge_id])
    membership = @challenge.membership_for(current_user)
    @group = @challenge.groups.build(group_params)
    @group.user_id = current_user.id 

    if @group.save
      unless @challenge.owner == current_user
        membership.group = @group
        membership.save
        MembershipCompletion.new(membership)
        GroupCompletion.new(@group)
      end
      flash[:notice] = "Group created successfully"
      redirect_to creator_challenge_path(@challenge.id)
    else
      flash[:notice] = "Group could not be created"
      render action: :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  private

  def group
    @group ||= Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
