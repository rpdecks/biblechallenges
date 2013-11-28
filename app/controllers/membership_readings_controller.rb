class MembershipReadingsController < ApplicationController

  def confirm
    @hash = params[:hash]
  end

  def log
    hashids = HashidsGenerator.instance
    membership_reading_id = hashids.decrypt(params[:hash])
    @membership_reading = MembershipReading.find_by_id(membership_reading_id)
    @membership_reading.state = 'read'
    @membership_reading.save!
    render_nothing
  end
end
