class Challenges::GroupsController < ApplicationController
  def show
    @challenge = Challenge.find(params[:challenge_id])
    @group = Group.find(params[:id])
  end
end
