class ChallengesController < ApplicationController
  def index
    if params[:query]
      @public_challenges = Challenge.search_by_name(params[:query])
    else
      @public_challenges = Challenge.includes(:members).current.at_least_5_members.sample(6)
    end

    if current_user
      @my_challenges = current_user.challenges.current
      unless params[:query]
        @public_challenges -= @my_challenges
      end
    end
  end

  def public_statistics
    @front_page_leaderboard = FrontPageLeaderboard.new
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
