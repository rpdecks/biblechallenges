class UserCompletion

  def initialize(user)
    ProfileAttacher.attach_profile(user)
    BadgeAttacher.attach_badges(user)
    UserStatisticAttacher.attach_statistics(user)
  end


end
