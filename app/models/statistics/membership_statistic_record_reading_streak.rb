class MembershipStatisticRecordReadingStreak < MembershipStatistic

  def name
    "Record Sequential Reading Count"
  end

  def description
    "much longer description here.............................."
  end
  # sequential means a streak within the challenge.  

  # Example 1: 
  # A person is one day behind, but reading regularly.
  # That person should have a sequential_reading stat that is high even though his punctuality is awful
  #
  # Question:  is consistency a better term than sequential?  should we use streak?  
  # 
  #
  # Example 2:  read one chapter, next day read 3, then next day read 1.  streak should be 3

  def calculate
    readings = self.membership.membership_readings.read
    record_streak(readings)
  end

  def update
    self.value = calculate
    save
  end

  def record_streak(readings)
    readings = readings.reverse
    streak_count = 0
    record_count = 0
    days = 0
    new_readings = readings.map(&:updated_at).collect { |d| d.strftime("%F")}.uniq()
  
    new_readings.each do |mr|
      if mr == days.day.ago.strftime("%F")
        streak_count+= 1
        days += 1
      else
        if streak_count > record_count
          record_count = streak_count
          streak_count = 0
        end
        until mr > days.day.ago.strftime("%F") do
          streak_count = 1
          days += 1
        end
      end
    end
    if streak_count > record_count
      return streak_count
    else
      return record_count
    end
  end

end
