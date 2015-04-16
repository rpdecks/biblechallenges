class PublicChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.all
  end
end
