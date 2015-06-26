require 'spec_helper'

describe ChallengeStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the ChallengeStatistics in the system to a challenge" do
      challenge = create(:challenge)
      ChallengeStatisticAttacher.attach_statistics(challenge)
      expect(challenge.challenge_statistics.size).to eq ChallengeStatistic.descendants.size
    end
    it "should only attach the statistics the challenge does not have" do
      challenge = create(:challenge)
      challenge.challenge_statistics << ChallengeStatisticChaptersRead.create
      ChallengeStatisticAttacher.attach_statistics(challenge)
      expect(challenge.challenge_statistics.size).to eq ChallengeStatistic.descendants.size
    end
  end


end
