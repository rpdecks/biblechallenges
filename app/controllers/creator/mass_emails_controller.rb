class Creator::MassEmailsController < ApplicationController
  before_filter :find_challenge

  def new
    @mass_email_form = MassEmail.new
  end

  def create
    all_members_in_challenge = @challenge.members
    all_members_in_challenge.pluck(:email)
  end

  private

  def find_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end
end
