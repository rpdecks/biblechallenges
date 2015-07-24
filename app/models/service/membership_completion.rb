class MembershipCompletion

  def initialize(membership, options={})
      MembershipStatisticAttacher.attach_statistics(membership)
      membership.update_stats   
      membership.challenge.update_stats  # this can definitely be backgrounded ask manny how todo
    if options.blank?
      membership.successful_creation_email
    else
      password = options[:password]
      membership.successful_auto_creation_email(membership, password)
    end
  end
end
