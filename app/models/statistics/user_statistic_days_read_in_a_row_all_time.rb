class UserStatisticDaysReadInARowAllTime < UserStatistic

  def name
    "User total number of consecutive reading days all-time"
  end

  def description
    "Records the longest streak of consecutive days with a membership reading, regardless of challenge."
  end

  def calculate
    user = self.user
    current_streak = user.user_statistics.find_by_type("UserStatisticDaysReadInARowCurrent").value.to_i
    all_time_streak = self.value.to_i
    if current_streak > all_time_streak
      self.value = current_streak.to_s
    else
      self.value
    end
  end

  def update
    self.value = calculate
    save
  end

end
