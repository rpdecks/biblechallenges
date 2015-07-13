class StatsService

  def update(membershipID)
    m = Membership.find(membershipID)
    m.update_stats
    m.group.update_stats if m.group
    m.challenge.update_stats
  end
end
