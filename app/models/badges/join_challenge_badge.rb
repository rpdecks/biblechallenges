class JoinChallengeBadge < Badge

  def name 
    "Join Challenge Badge"
  end

  def description
    "you get this badge when you have joined a challenge"
  end

  def img
    "http://placehold.it/40x40"
  end

  def qualify?
    user.memberships.count > 0
  end


end
