class UserStatisticDaysReadInARowCurrent < UserStatistic

  def name
    "Current streak for days read in a row"
  end

  def description
    "Records the active streak of consecutive days with a membership reading, regardless of challenge."
  end

  def calculate
    user = self.user
    all_user_readings = user.membership_readings.all
    current_reading = user.membership_readings.last
    previous_day = (current_reading.created_at - 1.day).utc.to_date
    @days_read = []
    all_user_readings.each do |r|
      @days_read << r.created_at.utc.to_date
    end
    if @days_read.include? previous_day
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
