class UserStatisticChaptersReadAllTime < UserStatistic

  def name
    "User total number of chapters read all-time"
  end

  def description
    "Records the number of chapters that the user has logged since joining as a member of Bible Challenges."
  end


  def calculate
    @total_read = []
    all_user_memberships = self.user.memberships
    all_user_memberships.each do |m|
      @total_read << m.membership_readings.count
    end
    @total_read.inject{|sum,x| sum + x }
  end

  def update
    if self.value == nil
      self.value = calculate
    else
      if calculate != 0
        old_value = self.value.to_i
        new_value = calculate
        diff = new_value - old_value
        updated_value = old_value + diff
        self.update_attributes(value: updated_value.to_s)
      else
        self.value
      end
    end
    save
  end

end
