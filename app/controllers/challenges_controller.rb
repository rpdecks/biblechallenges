class ChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.all.includes(:members, :readings, :membership_readings)
  end
end
