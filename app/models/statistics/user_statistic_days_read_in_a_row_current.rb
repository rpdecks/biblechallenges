class UserStatisticDaysReadInARowCurrent < UserStatistic

  def name
    "Current streak for days read in a row"
  end

  def description
    "Records the active streak of consecutive days with a membership reading, regardless of challenge."
  end

  def calculate
    user = self.user
    readings = user.membership_readings.all
    current_reading = user.membership_readings.last
    current_reading_date = Time.now.utc.to_date
    if current_reading_date == current_reading.created_at.time.utc.to_date
      reading_streak = self.value.to_i
      new_reading_streak = reading_streak += 1
      self.value = new_reading_streak
    else
      self.value = 1
    end
  end

  def update
    self.value = calculate
    save
  end
end
