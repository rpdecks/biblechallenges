class MembershipReadingsController < ApplicationController
  respond_to :html, :json
  acts_as_token_authentication_handler_for User, only: [:create]
  before_filter :authenticate_user! # needs to follow token_authentication_handler

  layout 'from_email'

  def create
    @challenge = membership.challenge
    reading
    if @challenge.has_member?(current_user) && membership.user == current_user
      @membership_reading = MembershipReading.create(membership_reading_params)

      update_stats

      respond_to do |format|
        format.html {
          # go back to referer unless alternate location passed in
          redirect = params[:location] || request.referer
          # might be an anchor tag
          redirect += params[:anchor] if params[:anchor]
          redirect_to redirect
        }
        format.json {
          render json: @membership_reading
        }
      end
    else
      raise "Not allowed"
    end
  end

  def update_stats
    #todo there is an issue here with stats updating themselves too quickly.
    # i.e, the challenge stats update before the membership stats finish
    # and so they are wrong because they are derived from those stats
    # probably the solution is to make a service object to update these stats
    # with an update_stats method that is delayed in its entirety via sidekiq
    # but executes these updates in sequence.  For now, I have removed the delay
    # so they will be accurate, but it will be a performance hit I think
    current_user.update_stats
    membership.update_stats
    membership.group.update_stats if membership.group
    membership.challenge.update_stats
  end

  def destroy
    @membership = membership_reading.membership
    @challenge = @membership.challenge
    if @challenge.has_member?(current_user) && @membership.user == current_user

      membership_reading.destroy

      update_stats

      respond_to do |format|
        format.html { 
          # go back to referer unless alternate location passed in
          redirect = params[:location] || request.referer
          # might be an anchor tag
          redirect += params[:anchor] if params[:anchor]
          redirect_to redirect
        }
        format.json { head :no_content }
      end
    else
      raise "Not allowed"
    end
  end

  def confirmation

  end

  def membership_reading_params
    params.permit(:reading_id, :membership_id)
  end

  def membership_reading
    @membership_reading ||= MembershipReading.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

  def reading
    @reading ||= Reading.find(params[:reading_id])
  end
end
