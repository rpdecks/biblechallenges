class ChallengesController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show]

  def new
    @challenge = Challenge.new
  end

  def index
    @challenges = (current_user.created_challenges + current_user.challenges).uniq
  end

  def show
    @readings  = @challenge.readings.order(:date)
  end

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def create
    @challenge = current_user.created_challenges.build(params[:challenge])
    flash[:notice] = "Successfully created Challenge" if @challenge.save
    redirect_to @challenge
  end

end
