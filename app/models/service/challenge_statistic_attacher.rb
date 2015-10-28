class ChallengeStatisticAttacher

  def self.attach_statistics(challenge)
    self.new.attach_statistics(challenge)
  end

  def attach_statistics(challenge)
    # creates any challengeStatistics for the challenge that the challengelacks
    @current_statistics = challenge.challenge_statistics.pluck(:type)
    @all_statistics = ChallengeStatistic.descendants.map(&:name)
    missing_statistics.each do |b|
      challenge.challenge_statistics << b.constantize.create
    end
  end

  def missing_statistics
    @all_statistics - @current_statistics
  end
end
