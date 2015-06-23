class UserStatisticDaysReadInARowAllTime < UserStatistic

  def name
    "User total number of consecutive reading days all-time"
  end

  def description
    "Records the longest streak of consecutive days with a membership reading, regardless of challenge."
  end

  def update
    best_streak = self.value.to_i
    current_streak = UserStatisticDaysReadInARowAllTime.value.to_i
    if current_streak > best_streak
      self.value = current_streak.to_s 
      save
    end
    current_streak(self.membership.membership_readings)  # some helper method to find the streak; pure ruby
  end

  def update
    self.value = calculate
    save
  end

  def current_streak(readings)
    readings = readings.reverse #something in query above is being overriden
   # membership_readings.uniq!{|mr| Date(mr.update_at) }
    streak_count = 0
    days = 0
    new_readings = readings.map(&:updated_at).collect { |d| d.strftime("%F")}.uniq()
  
    new_readings.each do |mr|
      if mr  == days.day.ago.strftime("%F")
        streak_count+= 1
        days += 1
      else
        return streak_count
      end
    end
    return streak_count
  end

end
