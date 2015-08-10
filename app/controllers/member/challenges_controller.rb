class Member::ChallengesController < ApplicationController
  respond_to :html, :js

  FIRST_VERSES_LIMIT = 10

  before_filter :authenticate_user!
  before_filter :find_challenge, only: [:destroy]

  def index
    # all challenges that user is a member of
    @challenges = current_user.challenges.newest_first
  end

  def show
    @challenge = Challenge.includes(:members).friendly.find(params[:id])
    @membership = @challenge.membership_for(current_user)
    @membership_readings = @membership.membership_readings if @membership
    @readings  = @challenge.readings.includes(:chapter).order(:read_on, :chapter_id)
    @group = current_user.find_challenge_group(@challenge)
    @groups = @challenge.groups.includes(:members,
                                         :group_statistic_progress_percentage,
                                         :group_statistic_on_schedule_percentage,
                                         :group_statistic_total_chapters_read)
    @user = current_user
    @todays_readings = @challenge.todays_readings.order(:chapter_id)
  end

  private

  def find_challenge
    @challenge = Challenge.includes(:chapters).find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :begindate, :enddate, :chapters_to_read, :dates_to_skip)
  end
end
