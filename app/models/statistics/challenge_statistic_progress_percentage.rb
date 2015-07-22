class ChallengeStatisticProgressPercentage < ChallengeStatistic

  def name
    "Challenge Progress Percentage"
  end

  def description
    "Percentage of the challenge completed by all members of the challenge in total"
  end

  def calculate
    total = challenge.memberships.map{|m| m.membership_statistic_progress_percentage.try(:value).to_i}.inject(0,:+)
    members_in_challenge.zero? ? 0 : total / challenge.memberships.size
  end

  def members_in_challenge
    challenge.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
