class MembershipStatisticTotalChaptersRead < MembershipStatistic


  def name
    "Total Chapters Read in this challenge"
  end

  def description
    ""
  end

  def calculate
    membership.membership_readings.size
  end

  def update
    self.value = calculate
    save
  end

end

