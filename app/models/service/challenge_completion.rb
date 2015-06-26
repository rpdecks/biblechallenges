class ChallengeCompletion

  def initialize(challenge)
    ChallengeStatisticAttacher.attach_statistics(challenge)
  end


end
