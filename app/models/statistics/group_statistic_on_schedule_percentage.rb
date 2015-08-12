class GroupStatisticOnSchedulePercentage < GroupStatistic

  def name
    "Group on_schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    if group_size == 0
      0
    else
      sum_of_percentages / group_size
    end
  end

  def update
    self.value = calculate
    save
  end

  private

  def sum_of_percentages
    array_of_percentages = group.memberships.map{|m| m.membership_statistic_on_schedule_percentage.try(:value)}
    result = array_of_percentages.inject(0,:+)
    result
  end

  def group_size
    group.memberships.count
  end

end
