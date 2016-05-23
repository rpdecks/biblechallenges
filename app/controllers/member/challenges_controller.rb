class Member::ChallengesController < ApplicationController
  respond_to :html, :js
  include Chartkick::Remote
  chartkick_remote

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
    @readings  = @challenge.readings.includes(:chapter).order(:read_on, :chapter_id)
    @group = current_user.find_challenge_group(@challenge)
    @groups = @challenge.groups.includes(:members,
                                         :group_statistic_progress_percentage,
                                         :group_statistic_on_schedule_percentage,
                                         :group_statistic_total_chapters_read)
    @member = current_user
    @todays_readings = @challenge.todays_readings(@member).order(:chapter_id)
    @challenge_chart_data = formatted_membership_readings_data_collector

    # generate json for group comments
    if @group
      @group_comments_json = eval(ActiveModel::ArraySerializer.new(@group.comments.recent_last, each_serializer: CommentSerializer).to_json)
      @current_user_json = eval(UserSerializer.new(current_user).to_json)
    end
  end

  private

  def formatted_membership_readings_data_collector
    [
      {
      name: "Benchmark",
      data: ChartDataGenerator.new(readings: @readings, membership_readings: @membership_readings).benchmark_data
      },
      {
      name: "#{@member.name}", #users whole challenge membership readings data
      data: ChartDataGenerator.new(readings: @readings, membership_readings: @membership_readings).member_reading_data
      }
    ]
  end

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
