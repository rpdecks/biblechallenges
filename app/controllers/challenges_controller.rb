class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.all #TODO: Paginate

    respond_to do |format|
      format.html
    end
  end

  def show
#    @challenge = Challenge.find_by_subdomain(request.subdomain)
#    @readings  = @challenge.readings
  end
end
