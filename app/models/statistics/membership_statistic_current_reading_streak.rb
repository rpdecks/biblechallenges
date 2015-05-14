class MembershipStatisticCurrentReadingStreak < MembershipStatistic

  def name
    "Current Sequential Reading Count"
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
    membership_readings = membership.membership_readings.
      where("membership_readings.updated_at <= ?", Date.today).
      where(state: "read").order('membership_readings.updated_at desc')
      binding.pry

    current_streak(membership_readings)  # some helper method to find the streak; pure ruby
  end

  def update
    self.value = calculate
    save
  end

  def current_streak(membership_readings)

    binding.pry
    streak_count = 0
    membership_readings.each do |mr|
      if #should check for consecutive days
        streak_count+= 1
      else
        break
      end
    end
    streak_count
  end
end
