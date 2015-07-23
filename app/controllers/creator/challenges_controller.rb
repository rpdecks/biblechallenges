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
    @challenge = Challenge.friendly.find_by_id(params[:id])
    redirect_to challenges_url if @challenge.nil?
  end

  def create
    @challenge = current_user.created_challenges.build(challenge_params)

#    @challenge.book_chapters = ActsAsScriptural.new.parse(@challenge.chapters_to_read).chapters

    # this seems terrible; is there a better way?  #jim
    if @challenge.save
      flash[:notice] = "Successfully created Challenge" 
      readings = ReadingsGenerator.new(@challenge).generate 

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


  def challenge_params
    params.require(:challenge).permit(:owner_id, :name, :dates_to_skip, :begindate, :enddate, :chapters_to_read, days_of_week_to_skip: [])
  end
end
