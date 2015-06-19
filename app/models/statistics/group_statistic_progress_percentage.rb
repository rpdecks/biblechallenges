class GroupStatisticProgressPercentage < GroupStatistic

  def name
    "Group progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    total = group.memberships.map{|m| m.membership_statistic_progress_percentage.value.to_i}.inject(:+)
    total / group.memberships.size
  end

  def update
    self.value = calculate
    save
  end

end
