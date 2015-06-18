class GroupStatisticOnSchedulePercentage < GroupStatistic

  def name
    "Group on_schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    member_on_schedule_percentages = group.memberships.map {|m| m.membership_statistic_on_schedule_percentage.value.to_i}
    member_on_schedule_percentages.inject{|sum, element| sum + element} / member_on_schedule_percentages.size
  end

  def update
    self.value = calculate
    save
  end

end
