class GroupStatisticPunctualPercentage < GroupStatistic

  def name
    "Group punctual percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    member_punctual_percentages = group.memberships.map {|m| m.membership_statistic_punctual_percentage.value.to_i}
    member_punctual_percentages.inject{|sum, element| sum + element} / member_punctual_percentages.size
  end

  def update
    self.value = calculate
    save
  end

end
