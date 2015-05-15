class GroupStatisticRecordSequentialReading < GroupStatistic

  def name
    "Group punctual percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    member_percentages = group.memberships.map {|m| m.membership_statistic_record_reading_streak.value.to_i}
    member_percentages.inject{|sum, element| sum + element} / member_percentages.size
  end

  def update
    self.value = calculate
    save
  end

end
