class Creator::ChallengesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show, :destroy, :edit, :update, :snapshot_email]
  before_action :validate_ownership, only: [:show, :edit, :destroy, :update]

  def new
    @challenge = Challenge.new
  end

  def index
    @challenges = current_user.created_challenges
  end

  def show
    @challenge = Challenge.includes(:members).friendly.find(params[:id])
    @challenge_members = @challenge.members
    @search = @challenge.memberships.search(params[:q])
    @challenge_memberships = @search.result
    @memberships = @challenge_memberships

    @groups = @challenge.groups.includes(:members,
                                         :group_statistic_progress_percentage,
                                         :group_statistic_on_schedule_percentage,
                                         :group_statistic_total_chapters_read)
    @readings  = @challenge.readings.order(:read_on)
  end

  def toggle
    @challenge = Challenge.friendly.find(params[:challenge_id])
    @challenge.toggle!(:joinable)
    redirect_to creator_challenge_path(@challenge)
  end

  def update
    @challenge.update_attributes(challenge_name)

    if @challenge.save
      redirect_to creator_challenge_path(@challenge), notice: "Successfully updated challenge"
    else
      flash[:error] = "Challenge cannot be updated. Please try again."
    end
  end

  def remove_member_from_challenge
    membership = Membership.find(params[:id])
    challenge = membership.challenge
    membership.destroy
    challenge.update_stats
    flash[:notice] = "You have successfully removed this member from the challenge"
    redirect_to creator_challenge_path(challenge)
  end

  def remove_group_from_challenge
    group = Group.find(params[:id])
    challenge = group.challenge
    group.remove_all_members_from_group
    group.destroy
    flash[:notice] = "You have successfully removed this group from the challenge"
    redirect_to creator_challenge_path(challenge)
  end

  def edit
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)

    if @challenge.save
      flash[:notice] = "Successfully created Challenge"

      ReadingsGenerator.new(@challenge).generate
      MembershipGenerator.new(@challenge, current_user).generate
      previous_challenge = Challenge.find(challenge_params[:previous_challenge_id]) if challenge_params[:previous_challenge_id].present?
      ImportsMembersFromPreviousChallenge.new(previous_challenge, @challenge).import
      ChallengeCompletion.new(@challenge)
      redirect_to member_challenge_path(@challenge)
    else
      render :new
    end
  end

  def destroy
    if @challenge.owner == current_user
      @challenge.destroy
      flash[:notice] = "Successfully deleted Challenge"
      redirect_to member_challenges_path
    end
  end

  def snapshot_email
    @challenge.send_challenge_snapshot_email_to_members
    flash[:notice] = "Successfully sent snapshot email to challenge members."
    redirect_to :back
  end

  private

  def find_challenge
    @challenge = Challenge.friendly.find(params[:id])
  end

  def challenge_name
    params.require(:challenge).permit(:name)
  end

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :users, :dates_to_skip, :begindate, :enddate, :chapters_to_read, :previous_challenge_id, :begin_book, :end_book, days_of_week_to_skip: [])
  end

  def validate_ownership
    @challenge = Challenge.friendly.find(params[:id])
    unless current_user == @challenge.owner
      flash[:notice] = "Access denied"
      redirect_to member_challenges_path
    end
  end
end
