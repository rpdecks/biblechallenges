class GroupStatisticOnSchedulePercentage < GroupStatistic

  def name
    "Group on_schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    total = group.memberships.map{|m| m.membership_statistic_on_schedule_percentage.try(:value)}.inject(:+)
    total / group.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
