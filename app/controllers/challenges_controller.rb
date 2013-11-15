class ChallengesController < ApplicationController

  before_filter :authenticate_user!  #, except: [:new, :create]

  def index
    @createdchallenges = current_user.createdchallenges
    @challenges = current_user.challenges
    respond_to do |format|
      format.html
    end
  end

  def show
#    @challenge = Challenge.find_by_subdomain(request.subdomain)
#    @readings  = @challenge.readings
  end
end
