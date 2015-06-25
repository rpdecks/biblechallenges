class ChallengeStatisticChaptersRead < ChallengeStatistic

  def name
    "Chapters Read"
  end

  def description
    "Sum of membership readings for all challenge members"
  end

  def calculate
    challenge.membership_readings.size
  end

  def update
    self.value = calculate
    save
  end

end
