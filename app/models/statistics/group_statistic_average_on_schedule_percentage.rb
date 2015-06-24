class GroupStatisticOnSchedulePercentage < GroupStatistic
  def name
    "Group's on schedule percentage"
  end

  def description
    "much longer description here.............................."
  end

  def calculate
    each_member_stats = []
    group.memberships.each do |m|
      each_member_stats << m.membership_statistics.find_by_type("MembershipStatisticOnSchedulePercentage").value.to_i
    end
    each_member_stats.sum / group.memberships.size
  end

  def update
    self.value = calculate
    save
  end
end
