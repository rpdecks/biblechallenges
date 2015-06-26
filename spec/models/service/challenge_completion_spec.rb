require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe ChallengeCompletion do

  describe "ChallengeStatistics" do
    it "should attach user statistics to the user" do
      allow(ChallengeStatisticAttacher).to receive(:attach_statistics)
      challenge = create(:challenge)

      ChallengeCompletion.new(challenge)

      expect(ChallengeStatisticAttacher).to have_received(:attach_statistics)
    end
  end


end
