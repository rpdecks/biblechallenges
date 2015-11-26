class Member::ChallengesController < ApplicationController
  respond_to :html, :js

  FIRST_VERSES_LIMIT = 10

  before_filter :authenticate_user!
  before_filter :authenticate_member, only: [:show]

  def index
    # all challenges that user is a member of
    @challenges = current_user.challenges.newest_first
    @user = current_user
  end

  def show
    @challenge = Challenge.includes(:members).friendly.find(params[:id])
    @membership = @challenge.membership_for(current_user)
    @membership_readings = @membership.membership_readings if @membership
    @readings  = @challenge.readings.includes(:chapter).order(:read_on, :chapter_id).page(params[:page]).per(50)
    @group = current_user.find_challenge_group(@challenge)
    @groups = @challenge.groups.includes(:members,
                                         :group_statistic_progress_percentage,
                                         :group_statistic_on_schedule_percentage,
                                         :group_statistic_total_chapters_read)
    @user = current_user
    @todays_readings = @challenge.todays_readings(@user).order(:chapter_id)
  end

  private

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :begindate, :enddate, :chapters_to_read, :dates_to_skip)
  end

  def authenticate_member
    challenge = Challenge.friendly.find(params[:id])
    unless challenge.memberships.pluck(:user_id).include? current_user.id #user not a member in challenge
      redirect_to challenge_path(challenge)
    end
  end
end
