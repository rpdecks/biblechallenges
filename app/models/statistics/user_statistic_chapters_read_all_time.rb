class UserStatisticChaptersReadAllTime < UserStatistic

  def name
    "Chapters read all-time"
  end

  def description
    "Records the number of chapters that the user has logged since joining as a member of Bible Challenges."
  end

  def calculate
    MembershipReading.where(user_id: user.id).count
  end

  def update
    self.value = calculate
    save
  end
end
