class MembershipReadingsController < ApplicationController

  before_filter :authenticate_user!, only: [:update]
  before_filter :find_membership_reading, expect: [:update]

  layout 'from_email'

  def update
    @membership_reading = MembershipReading.find_by_id(params[:id])
    @membership = @membership_reading.membership
    @membership_reading.state = (params[:state] == 'read') ? 'read' : 'unread'
    @membership_reading.save!
  end

  def confirm
    if @membership_reading
      @hash = params[:hash]
      @user = @membership_reading.membership.user
      @reading = @membership_reading.reading
    else
      flash[:error] = "This confirmation link doesn't exist"
    end
  end

  def log
    @membership = @membership_reading.membership
    @reading = @membership_reading.reading

    @membership_reading.state = 'read'
    @membership_reading.save!
  end

  private

  def find_membership_reading
    hashids = HashidsGenerator.instance
    membership_reading_id = hashids.decrypt(params[:hash])
    @membership_reading = MembershipReading.find_by_id(membership_reading_id)
  end

end