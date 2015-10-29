class MembershipCompletion

  def initialize(membership, options={})
    @membership = membership
    @options = options
    complete
  end

  def complete
    @membership.update_stats

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
