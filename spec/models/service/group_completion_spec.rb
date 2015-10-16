require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe GroupCompletion do

  describe "GroupStatistics" do
    it "should update group statistics" do
      group = stub("group")
      allow(group).to receive(:update_stats)

      GroupCompletion.new(group)

      expect(group).to have_received(:update_stats)
    end
  end


end
