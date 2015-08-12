class GroupStatisticRecordSequentialReading < GroupStatistic

  def name
    "Group on schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    if group_size == 0
      0
    else
      total = group.memberships.map{|m| m.membership_statistic_record_reading_streak.try(:value)}.inject(:+)
      total / group_size
    end
  end

  def update
    self.value = calculate
    save
  end

  private

  def group_size
    group.memberships.count
  end

end
