class Creator::ChallengesController < ApplicationController
  before_filter :authenticate_user!, except: [:new]

  def index

  end


  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = current_user.createdchallenges.build(params[:challenge])
    if @challenge.save
      flash[:notice] = "Successfully created Challenge"
      redirect_to creator_challenges_url
    else
      render :action => 'new'
    end
  end

end
