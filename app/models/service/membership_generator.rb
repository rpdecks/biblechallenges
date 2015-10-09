class MembershipGenerator
  def initialize(challenge, *users)
    @challenge = challenge
    @users = users.flatten
  end

  def generate
    @users.each do |u|
      membership = Membership.new
      membership.user = u
      membership.challenge = @challenge
      membership.save

      MembershipCompletion.new(membership)
    end
  end
end
