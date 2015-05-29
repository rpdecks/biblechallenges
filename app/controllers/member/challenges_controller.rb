class Member::ChallengesController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show, :destroy]

  def new
    @challenge = Challenge.new
  end

  def index
    # this gets all challenges that you own or are a member of
    @challenges = (current_user.created_challenges + current_user.challenges).uniq
  end

  def show
    @readings  = @challenge.readings.order(:date)
    @membership = @challenge.membership_for(current_user)
  end

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)
    flash[:notice] = "Successfully created Challenge" if @challenge.save
    @challenge.generate_readings
    redirect_to @challenge
  end

  def destroy
    @challenge.destroy
    redirect_to member_challenges_path
  end

  private

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :begindate, :enddate, :chapters_to_read)
  end
end
