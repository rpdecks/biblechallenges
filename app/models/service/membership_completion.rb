class MembershipCompletion

  def initialize(membership)
    MembershipStatisticAttacher.attach_statistics(membership)
    membership.update_stats   
    membership.challenge.update_stats  # this can definitely be backgrounded ask manny how todo
    membership.successful_creation_email #todo can this be delayed by membership.delay.successful_creation_email
  end

end
