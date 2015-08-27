class GroupScore

  def initialize(group)
    @group = group 
  end

  def score
    group_size = @group.members.size
    total_score = 0

    group.memberships.each do |m|
      total_score += MembershipScore.new(m).score
    end

    return total_score / group_size
  end
end

