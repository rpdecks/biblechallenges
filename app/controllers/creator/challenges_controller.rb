class Creator::ChallengesController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show, :destroy]

  def new
    @challenge = Challenge.new
  end

  def index
    @challenges = current_user.created_challenges
  end

  def show
    @readings  = @challenge.readings.order(:date)
  end

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)
    flash[:notice] = "Successfully created Challenge" if @challenge.save
    @challenge.generate_readings
    redirect_to [:creator, @challenge]
  end

  def destroy
    @challenge.destroy
    redirect_to creator_challenges_path
  end

  private

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :begindate, :enddate, :chapters_to_read)
  end
end
