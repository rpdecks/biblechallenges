class UserStatisticChaptersReadAllTime < UserStatistic

  def name
    "User total number of chapters read all-time"
  end

  def description
    "Records the number of chapters that the user has logged since joining as a member of Bible Challenges."
  end

  def update
    current_count = self.value.to_i
    total_count = current_count += 1
    self.value = total_count.to_s
    save
  end
end
