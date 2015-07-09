class MembershipCompletion

  def initialize(membership)
    MembershipStatisticAttacher.attach_statistics(membership)
    membership.successful_creation_email
    #todays_readings = membership.readings.todays_reading
    #ReadingMailer.daily_reading_email(membership.readings.todays_reading.id, membership.user_id)
  end


end
