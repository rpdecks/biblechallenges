require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe ChallengeCompletion do

  describe "ChallengeStatistics" do
    it "should attach user statistics to the user" do
      challenge = double(:challenge)
      allow(ChallengeStatisticAttacher).to receive(:attach_statistics)
      allow(challenge).to receive(:update_stats)

      ChallengeCompletion.new(challenge)

      expect(challenge).to have_received(:update_stats)
    end
  end


end
