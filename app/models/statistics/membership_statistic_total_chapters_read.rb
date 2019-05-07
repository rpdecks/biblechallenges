class MembershipStatisticTotalChaptersRead < MembershipStatistic


  def name
    "Total Chapters Read in this challenge"
  end

  def description
    ""
  end

  def calculate
    membership.membership_readings.count
  end

  def update
    self.update(value: calculate)
  end

end

