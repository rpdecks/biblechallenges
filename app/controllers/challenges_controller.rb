class ChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.
      all.includes(:members, :readings, :membership_readings)
    if params[:query]
      @public_challenges = @public_challenges.search_by_name(params[:query]) 
    end
  end

  def show
    challenge
    redirect_to member_challenge_path(challenge) if challenge.membership_for(current_user)
  end


  private

  def challenge
    @challenge ||= Challenge.find(params[:id])
  end
end
