class MembershipGenerator
  def initialize(challenge, *users)
    @challenge = challenge
    @users = users.flatten
  end

  def generate
    new_members.each do |u|
      membership = Membership.new
      membership.user = u
      membership.challenge = @challenge
      membership.save

      MembershipCompletion.new(membership)
    end
  end

  private

  def new_members
    @users - @challenge.members
  end
end
