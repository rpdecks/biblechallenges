class GroupCompletion

  def initialize(group)
    GroupStatisticAttacher.attach_statistics(group)
  end


end
