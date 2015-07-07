require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe MembershipCompletion do

  describe "MembershipStatistics" do
    it "should attach user statistics to the user" do
      allow(MembershipStatisticAttacher).to receive(:attach_statistics)
      membership = create(:membership, challenge: create(:challenge))

      MembershipCompletion.new(membership)

      #todo ugh ugh this is because of the callback in challenge to attach member stats to the creator
      # must fix
      expect(MembershipStatisticAttacher).to have_received(:attach_statistics).exactly(2).times
    end
  end


end
