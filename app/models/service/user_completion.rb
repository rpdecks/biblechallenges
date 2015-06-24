class UserCompletion
  def initialize(user)
    BadgeAttacher.attach_badges(user)
  end
end
