class Member::ChallengesController < ApplicationController
  respond_to :html, :js

  FIRST_VERSES_LIMIT = 10

  before_filter :authenticate_user!
  before_filter :find_challenge, only: [:destroy]

  def index
    # all challenges that user is a member of
    @challenges = current_user.challenges.uniq
  end

  def show
    @challenge = Challenge.includes({members: :profile}).find_by_id(params[:id])
    @membership = @challenge.membership_for(current_user)
    @membership_readings = @membership.membership_readings if @membership
    @readings  = @challenge.readings.includes(:chapter).order(:read_on)
    @group = current_user.find_challenge_group(@challenge)
    @groups = @challenge.groups.includes(:members)
    @user = current_user
    @todays_reading = @challenge.todays_reading
    if @todays_reading
      @first_verses_in_todays_reading = @todays_reading.chapter.verses.
        by_version(@membership.bible_version).
        by_range(end_verse: FIRST_VERSES_LIMIT)
      @remaining_verses_in_todays_reading = @todays_reading.chapter.verses.
        by_version(@membership.bible_version).
        by_range(start_verse: FIRST_VERSES_LIMIT + 1)
    end
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
