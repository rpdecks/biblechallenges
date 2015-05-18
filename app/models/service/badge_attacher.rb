class BadgeAttacher



  def self.attach_badges(user)
    self.new.attach_badges(user)
  end


  def attach_badges(user)
    user_badges = user.badges.pluck(:type)
    all_badges = Badge.descendants.map(&:name)
    missing_badges = all_badges - user_badges
    missing_badges.each do |b|
      user.badges << b.constantize.create
    end
  end
end
