class MembershipGenerator
  def initialize(challenge, *new_members)
    @challenge = challenge
    @new_members = new_members.flatten
  end

  def generate
    new_members_not_in_this_challenge.each do |new_member|
      membership = Membership.create(user: new_member, challenge: @challenge)
      MembershipCompletion.new(membership)
    end
  end

  private

  def new_members_not_in_this_challenge
    @new_members - @challenge.members
  end
end
