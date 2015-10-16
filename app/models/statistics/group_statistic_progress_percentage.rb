class GroupStatisticProgressPercentage < GroupStatistic

  def name
    "Group progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    if group_size == 0
      0
    else
      total = group.memberships.map{|m| m.membership_statistic_progress_percentage.try(:value) || 0}.inject(:+)
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
