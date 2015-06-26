class ChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.includes(:members)
    if params[:query]
      @public_challenges = @public_challenges.search_by_name(params[:query])
    end
  end

  def show
    @challenge = Challenge.includes(:members).find(params[:id])
    @readings = challenge.readings.includes(:chapter)
    redirect_to member_challenge_path(challenge) if challenge.membership_for(current_user)
  end

  private

  def challenge
    @challenge ||= Challenge.find(params[:id])
  end
end
