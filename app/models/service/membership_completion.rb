class MembershipCompletion

  def initialize(membership)
    MembershipStatisticAttacher.attach_statistics(membership)
    membership.successful_creation_email

    todays_reading = membership.readings.todays_reading

    if todays_reading.size > 0
      ReadingMailer.daily_reading_email(todays_reading.first.id, membership.user_id).deliver_now
    end
  end


end
