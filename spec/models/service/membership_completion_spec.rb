require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe MembershipCompletion do

  describe "MembershipStatistics" do
    it "should attach user statistics to the user" do
      allow(MembershipStatisticAttacher).to receive(:attach_statistics)
      ch = create(:challenge, :with_membership)
      membership = ch.memberships.first

      MembershipCompletion.new(membership)

      expect(MembershipStatisticAttacher).to have_received(:attach_statistics).exactly(1).times
    end
  end


end
