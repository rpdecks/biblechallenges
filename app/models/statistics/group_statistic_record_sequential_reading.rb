class GroupStatisticRecordSequentialReading < GroupStatistic

  def name
    "Group on schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    total = group.memberships.map{|m| m.membership_statistic_record_reading_streak.try(:value)}.inject(:+)
    total / group.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
