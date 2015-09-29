class MembershipStatisticOnSchedulePercentage < MembershipStatistic

  def name
    "Overall on_schedule  percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    readings_to_date = membership.readings.to_date(Time.current.utc.yesterday.to_date)
    on_schedule_membership_readings = membership.membership_readings.on_schedule
    on_time_readings = 0

    on_schedule_membership_readings.each do |mr|
      if readings_to_date.include?(mr.reading)
        on_time_readings += 1
      end
    end

    readings_to_date.size.zero? ? 0 : (on_time_readings * 100) / readings_to_date.size 
  end

  def update
    self.value = calculate
    save
  end

end
