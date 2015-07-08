class MembershipStatisticCurrentReadingStreak < MembershipStatistic

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
  # Example 3:  read one chapter, next day read 3, then next day read 1, then next day have not read. Streak should be 3, because the day that breaks streak has not passed

  def calculate
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

    if (new_readings[0] == 1.days.ago.strftime("%F"))
      days +=1
    end

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
