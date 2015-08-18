class MembershipCompletion

  def initialize(membership, options={})
      MembershipStatisticAttacher.attach_statistics(membership)
      membership.update_stats   
      membership.challenge.update_stats  # this can definitely be backgrounded ask manny how todo
    if options.blank?
      if membership.user_id == membership.challenge.owner_id #challenge owner will not receive "Thanks for joing" email
        membership.send_reading_email
      else
        membership.successful_creation_email
      end
    else
      password = options[:password]
      membership.successful_auto_creation_email(membership, password)
    end
  end
end
