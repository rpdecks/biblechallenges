class Creator::MassEmailsController < ApplicationController
  before_filter :find_challenge
  before_action :validate_ownership, only: [:new, :create]

  def create
    email_array = @challenge.all_users_emails_except_challenge_owner
    if params[:message].present?
      flash[:notice] = "You have successfully sent your message"
      message = params[:message]
      @challenge.send_challenge_msg_via_email(email_array, message, @challenge.id)
      flash[:notice] = "You have successfully sent your message"
      redirect_to creator_challenge_path(@challenge)
    else
      flash[:notice] = "You need to include a message"
      redirect_to new_creator_challenge_mass_email_path(@challenge.id)
    end
  end

  private

  def find_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def validate_ownership
    @challenge = Challenge.friendly.find(params[:challenge_id])
    unless current_user == @challenge.owner
      flash[:notice] = "Access denied"
      redirect_to member_challenges_path
    end
  end
end
