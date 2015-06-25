require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe MembershipCompletion do

  describe "MembershipStatistics" do
    it "should attach user statistics to the user" do
      allow(MembershipStatisticAttacher).to receive(:attach_statistics)
      membership = create(:membership, challenge: create(:challenge))

      MembershipCompletion.new(membership)

      expect(MembershipStatisticAttacher).to have_received(:attach_statistics)
    end
  end


end
