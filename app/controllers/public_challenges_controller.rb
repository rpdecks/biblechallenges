class PublicChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.non_private.limit(10)
  end
end
