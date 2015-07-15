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

    # this seems terrible; is there a better way?  #jim
    if @challenge.save
      flash[:notice] = "Successfully created Challenge" 
      readings = ReadingsGenerator.new(@challenge.begindate, 
                                      @challenge.chapters_to_read,
                                      days_of_week_to_skip: days_of_week_to_skip,
                                      dates_to_skip: challenge_params[:dates_to_skip],
                                      ).generate

      Reading.transaction do
        readings.each do |r|
          Reading.connection.execute "INSERT INTO readings (chapter_id, challenge_id, read_on) values (#{r.chapter_id}, #{@challenge.id}, '#{r.read_on}')"
        end
      end

      membership = Membership.new
      membership.user = current_user
      membership.challenge = @challenge
      membership.save

      MembershipCompletion.new(membership)
      ChallengeCompletion.new(@challenge)
    end

    redirect_to member_challenges_path
  end

  def destroy
    if @challenge.owner == current_user
      @challenge.destroy
      flash[:notice] = "Successfully deleted Challenge" 
      redirect_to member_challenges_path
    end
  end

  def days_of_week_to_skip
    if params[:days_to_skip]
      params[:days_to_skip].map{|i| i.to_i} 
    end
  end

  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :dates_to_skip, :begindate, :enddate, :chapters_to_read)
  end
end
