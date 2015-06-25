class UserStatisticDaysReadInARowAllTime < UserStatistic

  def name
    "User total number of consecutive reading days all-time"
  end

  def description
    "Records the longest streak of consecutive days with a membership reading, regardless of challenge."
  end

  def calculate
    user = self.user
    membership_readings = user.membership_readings
    if membership_readings.any?
      streaks = user.membership_readings.map{|mr| mr.created_at.utc.to_date.jd}.sort.find_consecutive
      if streaks.any?
        max_streak = streaks.max {|a,b| a.size <=> b.size}
        max_streak.size
      else
        max_streak = 1
      end
    else
      return 0 
    end
  end

  def update
    self.value = calculate
    save
  end

end
