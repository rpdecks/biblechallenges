class UserCompletion

  def initialize(user)
    ProfileAttacher.attach_profile(user)
    BadgeAttacher.attach_badges(user)
  end


end
