require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe GroupCompletion do

  describe "GroupStatistics" do
    it "should attach group statistics to the group" do
      allow(GroupStatisticAttacher).to receive(:attach_statistics)
      group = create(:group, challenge: create(:challenge))

      GroupCompletion.new(group)

      expect(GroupStatisticAttacher).to have_received(:attach_statistics)
    end
  end


end
