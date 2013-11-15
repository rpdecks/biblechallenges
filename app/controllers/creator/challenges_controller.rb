class Creator::ChallengesController < ApplicationController
  before_filter :authenticate_user!  #, except: [:new, :create]

  def index
    @challenges = current_user.createdchallenges
  end

  def show
    @challenge = current_user.createdchallenges.find(params[:id])
  end

  def update
    @challenge = current_user.createdchallenges.find(params[:id])
    if @challenge.update_attributes(params[:challenge])
      redirect_to creator_challenge_path(@challenge)
    else
      render :action => 'new'
    end
  end

  def activate
    @challenge = current_user.createdchallenges.find(params[:id])
    @challenge.active = true
    if @challenge.save
      flash[:notice] = "You have successfully activated your Bible Challenge"
      redirect_to creator_challenges_path
    else
      render :action => 'show'
    end
  end

  def edit
    @challenge = current_user.createdchallenges.find(params[:id])
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = current_user.createdchallenges.build(params[:challenge])
    if @challenge.save
      flash[:notice] = "Successfully created Challenge"
      redirect_to creator_challenge_path(@challenge)
    else
      render :action => 'new'
    end
  end

end
