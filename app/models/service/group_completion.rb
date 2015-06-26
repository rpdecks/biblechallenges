class GroupCompletion

  def initialize(membership)
    GroupStatisticAttacher.attach_statistics(membership)
  end


end
