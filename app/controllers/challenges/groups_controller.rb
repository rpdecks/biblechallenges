class Challenges::GroupsController < ApplicationController

  before_filter :find_challenge, :find_group, :except => [:create, :new]

  def show
  end

  def join
    @group.add_user_to_group(@challenge, current_user)
    redirect_to [@challenge, @group]
  end

  def leave
    @group.remove_user_from_group(@challenge, current_user)
    redirect_to [@challenge]
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
    @group.remove_all_members_from_group
    if @group.destroy
      flash[:notice] = "Group deleted successfully"
      redirect_to @challenge
    else
      flash[:notice] = "Group could not be deleted"
      redirect_to [@challenge, @group]
    end
  end

  private

  def find_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
