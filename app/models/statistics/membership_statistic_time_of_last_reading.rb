class MembershipStatisticTimeOfLastReading < MembershipStatistic


  def name
    "Time of last reading"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    membership.membership_readings.order(:created_at).last.try(:created_at)
  end

  def update
    self.update(value: calculate)
  end

end

