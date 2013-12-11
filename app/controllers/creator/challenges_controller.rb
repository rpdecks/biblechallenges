class Creator::ChallengesController < ApplicationController
  before_filter :authenticate_user!  #, except: [:new, :create]
  before_filter :find_challenge, except: [:index,:new,:create]

  respond_to :html, :json, :js

  def index
    @challenges = current_user.created_challenges
    respond_with(:creator,@challenges)
  end

  def show
    respond_with(:creator,@challenge)
  end

  def update
    flash[:notice] = "Challenge successfully updated" if @challenge.update_attributes(params[:challenge])
    respond_with(:creator,@challenge)
  end

  def activate
    @challenge.active = true
    if @challenge.save
      flash[:notice] = "You have successfully activated your Bible Challenge"
      redirect_to creator_challenges_path
    else
      render action: 'show'
    end
  end

  def edit
    respond_with(:creator,@challenge)
  end

  def new
    @challenge = Challenge.new
    respond_with(:creator,@challenge)
  end

  def create
    @challenge = current_user.created_challenges.build(params[:challenge])
    flash[:notice] = "Successfully created Challenge" if @challenge.save
    respond_with(:creator,@challenge)
  end

  def destroy
    name = @challenge.name
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to creator_challenges_url, notice: "#{name.capitalize} challenge was successfully deleted" }
      format.json { head :no_content }
    end
  end

  def confirm_destroy
    respond_with(:creator,@challenge)
  end

  private

  def find_challenge
    @challenge = current_user.created_challenges.find(params[:id])
    redirect_to creator_challenges_url if @challenge.nil?
  end

end
