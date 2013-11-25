class ChallengesController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show]

  def index
    @createdchallenges = current_user.createdchallenges
    @challenges = current_user.challenges
    respond_to do |format|
      format.html
    end
  end

  def show
    @readings  = @challenge.readings
  end

  private

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id]) || Challenge.find_by_subdomain(request.subdomain)
    redirect_to challenges_url if @challenge.nil?
  end

end
