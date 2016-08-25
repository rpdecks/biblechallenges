class UserCompletion
  def initialize(user)
    BadgeAttacher.attach_badges(user)
    UserStatisticAttacher.attach_statistics(user)
    AvatarlyAttacher.new(user).attach
  end
end
