class MembershipCompletion

  def initialize(membership)
    MembershipStatisticAttacher.attach_statistics(membership)
#    membership.successful_creation_email

#    todays_reading = membership.readings.todays_reading
#
#    if todays_reading.size > 0
#      DailyEmailWorker.perform_in(1.minute, todays_reading.first.id, membership.user_id)
#    end
  end


end
