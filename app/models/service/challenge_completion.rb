class ChallengeCompletion
  def initialize(challenge)
    ChallengeStatisticAttacher.attach_statistics(challenge)
    challenge.update_stats
  end
end
