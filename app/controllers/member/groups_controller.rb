class Member::GroupsController < ApplicationController
  def show
    group
  end

  def join
    group.add_user_to_group(group.challenge, current_user)
    flash[:notice] = "Joined group successfully"
    redirect_to member_challenge_path(group.challenge, anchor: "readings")
  end

  def leave
    group.remove_user_from_group(group.challenge, current_user)
    flash[:notice] = "Left group successfully"
    redirect_to member_challenge_path(group.challenge, anchor: "groups")
  end

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.new
  end

  def create
    @challenge = Challenge.find(params[:challenge_id])
    membership = @challenge.membership_for(current_user)
    @group = @challenge.groups.build(group_params)
    @group.user_id = current_user.id

    if @group.save
      membership.group = @group 
      membership.save
      flash[:notice] = "Group created successfully"
      redirect_to @challenge
    else
      flash[:notice] = "Group could not be created"
      render action: :new
    end
  end

  def destroy
    challenge = group.challenge
    group.remove_all_members_from_group
    if group.destroy
      flash[:notice] = "Group deleted successfully"
      redirect_to [:member, challenge]
    else
      flash[:notice] = "Group could not be deleted"
      redirect_to [:member, group]
    end
  end

  private

  def group
    @group ||= Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
