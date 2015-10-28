require 'spec_helper'

describe ChallengeStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the ChallengeStatistics in the system to a challenge" do
      challenge_statistics = double(:challenge_statistics, pluck: []).as_null_object
      challenge = double(:challenge, challenge_statistics: challenge_statistics)
      allow(ChallengeStatistic).to receive(:create)

      ChallengeStatisticAttacher.attach_statistics(challenge)

      expect(ChallengeStatistic).to have_received(:create).exactly(num_challenge_statistics).times
    end

    it "should only attach the statistics the challenge does not have" do
      challenge_statistics = double(:challenge_statistics, pluck: [challenge_statistics_names.first]).as_null_object
      challenge = double(:challenge, challenge_statistics: challenge_statistics)
      allow(ChallengeStatistic).to receive(:create)

      ChallengeStatisticAttacher.attach_statistics(challenge)

      expect(ChallengeStatistic).to have_received(:create).exactly(num_challenge_statistics - 1).times
    end
  end

  def num_challenge_statistics
    ChallengeStatistic.descendants.size
  end

  def challenge_statistics_names
    ChallengeStatistic.descendants.map(&:name)
  end
end
