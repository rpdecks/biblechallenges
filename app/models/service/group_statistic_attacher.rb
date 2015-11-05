class GroupStatisticAttacher

  def self.attach_statistics(group)
    self.new.attach_statistics(group)
  end

  def attach_statistics(group)
    # creates any groupStatistics for the group that the group lacks
    @current_statistics = group.group_statistics.pluck(:type)
    @all_statistics = GroupStatistic.descendants.map(&:name)
    missing_statistics.each do |b|
      group.group_statistics << b.constantize.create
    end
  end

  def missing_statistics
    @all_statistics - @current_statistics
  end
end
