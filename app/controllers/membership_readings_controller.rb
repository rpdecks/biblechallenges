class MembershipReadingsController < ApplicationController

  before_filter :authenticate_user!

  acts_as_token_authentication_handler_for User, only: [:create, :destroy]

  layout 'from_email'

  def create
    MembershipReading.create(membership_reading_params)
    redirect_to :back
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
