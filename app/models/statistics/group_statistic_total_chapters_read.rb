class GroupStatisticTotalChaptersRead < GroupStatistic

  def name
    "Total Chapters Read"
  end

  def description
    "The total number of chapters read by this group"
  end

  def calculate
    total = 0
    group.memberships.each do |m|
      total += m.membership_readings.size
    end
    total
  end

  def update
    self.value = calculate
    save
  end

end
