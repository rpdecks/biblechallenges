class ChallengeStatisticOnSchedulePercentage < ChallengeStatistic

  def name
    "Challenge on_schedule percentage"
  end

  def description
    "Percentage of membership readings that are read on-schedule within a challenge"
  end

  def calculate
    members_in_challenge.zero? ? 0 : sum_of_percentages / members_in_challenge
  end

  def update
    self.value = calculate
    save
  end

  def members_in_challenge
    challenge.memberships.size
  end

  def sum_of_percentages
    challenge.memberships.map{|m| m.membership_statistic_on_schedule_percentage.try(:value).to_i}.inject(0,:+)
  end
end
