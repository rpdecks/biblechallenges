class Creator::ChallengesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :find_challenge, only: [:show, :destroy, :edit, :update]

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
    @challenge = Challenge.friendly.find(params[:id])
  end

  def update
    @challenge.update_attributes(challenge_name)

    if @challenge.save
      redirect_to member_challenge_path(@challenge), notice: "Successfully updated challenge"
    else
      flash[:error] = "Challenge cannot be updated. Please try again."
    end
  end

  def edit
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)

    if @challenge.save
      flash[:notice] = "Successfully created Challenge"
      ReadingsGenerator.new(@challenge).generate

      membership = Membership.new
      membership.user = current_user
      membership.challenge = @challenge
      membership.save

      MembershipCompletion.new(membership)
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

  private

  def challenge_name
    params.require(:challenge).permit(:name)
  end

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :dates_to_skip, :begindate, :enddate, :chapters_to_read, days_of_week_to_skip: [])
  end
end
