class MembershipCompletion

  def initialize(membership)
    MembershipStatisticAttacher.attach_statistics(membership)
  end


end
