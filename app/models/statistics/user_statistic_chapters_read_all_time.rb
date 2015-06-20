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
      old_value = self.value.to_i
    binding.pry
      new_value = calculate
    binding.pry
      total_value = old_value + new_value
    binding.pry
      self.update_attributes(value: total_value.to_s)
    end
    save
  end

end
