class UserStatisticDaysReadInARowAllTime < UserStatistic

  def name
    "All-time streak for days read in a row"
  end

  def description
    "Records the longest streak of consecutive days with a membership reading, regardless of challenge."
  end

  def calculate

    user = self.user
    membership_readings = MembershipReading.where(user_id: user.id)
    if membership_readings.any?

      streaks = MembershipReading.where(user_id: user.id).
        map{|mr| mr.created_at.in_time_zone(user.time_zone).to_date.jd}.
        sort.uniq.find_consecutive

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
