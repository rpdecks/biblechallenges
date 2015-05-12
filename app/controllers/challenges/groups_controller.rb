class Challenges::GroupsController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.find(params[:id])
  end

  def join
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.find(params[:id])

    membership = @challenge.membership_for(current_user) || Membership.new(user_id: current_user.id)
    membership.challenge = @challenge
    membership.group = @group
    membership.save
    
    redirect_to [@challenge, @group]
  end


end
