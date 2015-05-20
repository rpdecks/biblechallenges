class MembershipStatisticPunctualPercentage < MembershipStatistic

  def name
    "Overall punctual  percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    td_total = membership.readings.to_date(Date.today).count
    punct_total = membership.membership_readings.punctual.count
    td_total.zero? ? 0 : (punct_total * 100) / td_total
  end

  def update
    self.value = calculate
    save
  end

end
