require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe MembershipCompletion do

  describe "MembershipStatistics" do
    it "should attach user statistics to the user" do
      allow(MembershipStatisticAttacher).to receive(:attach_statistics)
      ch = create(:challenge, :with_membership, :with_readings)
      membership = ch.memberships.first

      MembershipCompletion.new(membership)
      NewChallengeEmailWorker.drain
      NewMembershipEmailWorker.drain
      DailyEmailWorker.drain

        expect(MembershipStatisticAttacher).to have_received(:attach_statistics).exactly(1).times
        #expecting 3 emails: Challenge creation, Challenge joined, Challegne daily reading email
        expect(ActionMailer::Base.deliveries.size).to eq 3
    end
  end


end
