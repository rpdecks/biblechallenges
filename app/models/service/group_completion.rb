class GroupCompletion

  def initialize(group)
    GroupStatisticAttacher.attach_statistics(group)
    group.update_stats
  end


end
