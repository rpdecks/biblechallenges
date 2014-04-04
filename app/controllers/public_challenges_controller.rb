class PublicChallengesController < ApplicationController
  def index
    @public_challenges = Challenge.public.limit(10)
  end
end
