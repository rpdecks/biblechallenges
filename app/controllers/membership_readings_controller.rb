class MembershipReadingsController < ApplicationController
  respond_to :html, :js
  acts_as_token_authentication_handler_for User, only: [:create]
  before_filter :authenticate_user! # needs to follow token_authentication_handler

  layout 'from_email'

  def create
    #jim do I need to instantiate @challenge @reading etc even though I may not need them?
    # can I re-render a smaller piece of the page to avoid needing these variables
    # how can I structure this create method so I can hit it from multiple places
    @challenge = membership.challenge
    reading
    MembershipReading.create(membership_reading_params)
    membership.update_stats
    respond_to do |format|
      format.html { 
        # go back to referer unless alternate location passed in
        redirect = params[:location] || request.referer
        # might be an anchor tag
        redirect += params[:anchor] if params[:anchor]
        redirect_to redirect
      }
      format.js { render :create }
    end
  end

  def destroy
    #jim this feel hokey because I want to pass in the id of the membership reading
    #but since I want to display this link before the actual record exists I'm 
    # doing it this way
    membership_reading.destroy
    respond_to do |format|
      format.html { 
        # go back to referer unless alternate location passed in
        redirect = params[:location] || request.referer
        # might be an anchor tag
        redirect += params[:anchor] if params[:anchor]
        redirect_to redirect
      }
      format.js { render :destroy }
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
