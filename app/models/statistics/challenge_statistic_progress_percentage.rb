class ChallengeStatisticProgressPercentage < ChallengeStatistic

  def name
    "Challenge Progress Percentage"
  end

  def description
    "Percentage of the challenge completed by all members of the challenge in total"
  end

  def calculate
    total = challenge.memberships.map{|m| m.membership_statistic_progress_percentage.value.to_i}.inject(:+)
    total / challenge.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
