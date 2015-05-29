class MembershipReadingsController < ApplicationController

  before_filter :authenticate_user!
  respond_to :html, :js

  acts_as_token_authentication_handler_for User, only: [:create, :destroy]

  layout 'from_email'

  def create
    #jim do I need to instantiate @challenge @reading etc even though I may not need them?
    # can I re-render a smaller piece of the page to avoid needing these variables
    # how can I structure this create method so I can hit it from multiple places
    @challenge = membership.challenge
    MembershipReading.create(membership_reading_params)
  end

  def destroy
    membership = membership_reading.membership
    membership_reading.destroy
    redirect_to [:member, membership]
  end

  private

  def membership_reading_params
    params.permit(:reading_id, :membership_id)
  end

  def membership_reading
    @membership_reading ||= MembershipReading.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

end
