class MembershipStatisticProgressPercentage < MembershipStatistic


  def name
    "Overall progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    mr_total = membership.readings.count
    read = membership.membership_readings.count
    mr_total.zero? ? 0 : (read * 100) / mr_total
  end

  def update
    self.value = calculate
    save
  end

end
