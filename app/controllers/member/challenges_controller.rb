class Member::ChallengesController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_user!
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
    @group = current_user.find_challenge_group(@challenge)
    @membership = @challenge.membership_for(current_user)
    @todays_reading = @challenge.todays_reading

    @readings_json = @challenge.readings.to_json(include: :chapter)
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

  def find_challenge
    @challenge = Challenge.find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :begindate, :enddate, :chapters_to_read, :dates_to_skip)
  end
end
