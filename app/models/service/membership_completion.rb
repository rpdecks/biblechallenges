class MembershipCompletion

  def initialize(membership, options={})
    @membership = membership
    @options = options
    complete
  end

  def complete
    MembershipStatisticAttacher.attach_statistics(@membership)
    @membership.update_stats   
    @membership.challenge.update_stats  # this can definitely be backgrounded ask manny how todo

    if password_passed_in?
      @membership.successful_auto_creation_email(@membership, @options[:password])
    else
      @membership.successful_creation_email
    end
    @membership.send_reading_email
  end

  private

  def password_passed_in?
    @options[:password]
  end

end
