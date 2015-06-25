class UserStatisticChaptersReadAllTime < UserStatistic

  def name
    "User total number of chapters read all-time"
  end

  def description
    "Records the number of chapters that the user has logged since joining as a member of Bible Challenges."
  end

  def calculate
    user.membership_readings.size
  end

  def update
    self.value = calculate
    save
  end
end
