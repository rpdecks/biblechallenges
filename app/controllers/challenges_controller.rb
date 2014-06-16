class ChallengesController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show]

  def index
    @created_challenges = current_user.created_challenges
    @challenges = current_user.challenges
    respond_to do |format|
      format.html
    end
  end

  def show
    @readings  = @challenge.readings.order(:date)
  end

  private

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id]) || Challenge.find_by_subdomain(request.subdomain)
    redirect_to challenges_url if @challenge.nil?
  end

end
