class MembershipStatisticAttacher

  def self.attach_statistics(membership)
    self.new.attach_statistics(membership)
  end

  def attach_statistics(membership)
    # creates any membershipStatistics for the membership that the membership lacks
    current_statistics = membership.membership_statistics.pluck(:type)
    all_statistics = MembershipStatistic.descendants.map(&:name)
    missing_statistics = all_statistics - current_statistics
    missing_statistics.each do |b|
      membership.membership_statistics << b.constantize.create
    end
  end
end
