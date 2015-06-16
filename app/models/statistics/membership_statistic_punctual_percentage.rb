class MembershipStatisticOnSchedulePercentage < MembershipStatistic

  def name
    "Overall on_schedule  percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    td_total = membership.readings.to_date(Date.today).count
    punct_total = membership.membership_readings.on_schedule.count
    td_total.zero? ? 0 : (punct_total * 100) / td_total
  end

  def update
    self.value = calculate
    save
  end

end
