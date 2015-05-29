class ChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.all.includes(:members, :readings, :membership_readings)
  end

  def show
    challenge
  end


  private

  def challenge
    @challenge ||= Challenge.find(params[:id])
  end
end
