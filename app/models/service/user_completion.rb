class UserCompletion
  def initialize(user)
    BadgeAttacher.attach_badges(user)
    UserStatisticAttacher.attach_statistics(user)
  end
end
