class GroupStatisticProgressPercentage < GroupStatistic

  def name
    "Group progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    member_progress_percentages = group.memberships.map {|m| m.membership_statistic_progress_percentage.value.to_i}
    member_progress_percentages.inject{|sum, element| sum + element} / member_progress_percentages.size
  end

  def update
    self.value = calculate
    save
  end

end
