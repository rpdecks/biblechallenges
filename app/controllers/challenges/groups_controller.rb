class Challenges::GroupsController < ApplicationController

  before_filter :find_challenge, :find_group

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

  private

  def find_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def find_group
    @group = Group.find(params[:id])
  end

end
