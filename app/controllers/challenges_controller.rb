class ChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.includes(:members).current

    if current_user
      @my_challenges = current_user.challenges.current
      @public_challenges -= @my_challenges
    end



    if params[:query]
      @public_challenges = @public_challenges.search_by_name(params[:query])
    end
  end

  def show
    @challenge = Challenge.includes(:members).friendly.find(params[:id])
    @readings = challenge.readings.includes(:chapter)
    redirect_to member_challenge_path(challenge) if challenge.membership_for(current_user)
  end

  private

  def challenge
    @challenge ||= Challenge.friendly.find(params[:id])
  end
end
