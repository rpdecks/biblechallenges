class UserStatisticAttacher

  def self.attach_statistics(user)
    self.new.attach_statistics(user)
  end

  def attach_statistics(user)
    # creates any UserStatistics for the user that the user lacks
    current_statistics = user.user_statistics.pluck(:type)
    all_statistics = UserStatistic.descendants.map(&:name)
    missing_statistics = all_statistics - current_statistics
    missing_statistics.each do |b|
      user.user_statistics << b.constantize.create
    end
  end
end
