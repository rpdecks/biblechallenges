class ChallengeStatisticOnSchedulePercentage < ChallengeStatistic

  def name
    "Challenge on_schedule percentage"
  end

  def description
    "Percentage of membership readings that are read on-schedule within a challenge"
  end

  def calculate
    total = challenge.memberships.map{|m| m.membership_statistic_on_schedule_percentage.value.to_i}.inject(:+)
    total / challenge.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
