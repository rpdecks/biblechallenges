class MembershipStatisticOverallProgressPercentage < MembershipStatistic

  def name
    "Overall progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def update
    mr_total = membership.membership_readings.count
    read = membership.membership_readings.read.count
    self.value = mr_total.zero? ? 0 : (read * 100) / mr_total
    save
  end

end
