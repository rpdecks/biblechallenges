class Challenges::GroupsController < ApplicationController

  before_filter :find_challenge, :find_group, :except => [:create, :new]

  def show
  end

  def join
    membership = @challenge.membership_for(current_user) || Membership.new(user_id: current_user.id)
    membership.challenge = @challenge
    membership.group = @group
    membership.save
    redirect_to [@challenge, @group]
  end

  def leave
    membership = @challenge.membership_for(current_user)
    membership.group = nil
    membership.save
    redirect_to [@challenge]
  end

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.new
  end

  def create
    @challenge = Challenge.find(params[:challenge_id])
    @group = @challenge.groups.build(group_params)
    @group.user_id = current_user.id

    if @group.save
      flash[:notice] = "Group created successfully"
      redirect_to @challenge
    else
      flash[:notice] = "Group could not be created"
      render action: :new
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
