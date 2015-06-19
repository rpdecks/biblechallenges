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
    self.value = calculate
    save
  end

end
