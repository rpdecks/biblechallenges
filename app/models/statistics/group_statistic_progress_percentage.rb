class GroupStatisticProgressPercentage < GroupStatistic

  def name
    "Group progress percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    sum_of_member_progress_percentages = 0
    membership_count = self.group.memberships.count
    self.group.memberships.each do |m| 
      member = Membership.find(m.id)
      sum_of_member_progress_percentages += member.progress_percentage
    end
    membership_count.zero? ? 0 : sum_of_member_progress_percentages / membership_count
  end

  def update
    self.value = calculate
    save
  end

end
