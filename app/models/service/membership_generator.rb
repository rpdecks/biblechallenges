class MembershipGenerator
  def initialize(*users)
    @users = users
  end

  def generate
    @users.each do |u|
      membership = Membership.new
      membership.user = current_user
      membership.challenge = @challenge
      membership.save

      MembershipCompletion.new(membership)
      ChallengeCompletion.new(@challenge)
      redirect_to member_challenge_path(@challenge)
    end
  end
end
