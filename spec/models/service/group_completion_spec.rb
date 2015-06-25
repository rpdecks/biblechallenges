require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe GroupCompletion do

  describe "GroupStatistics" do
    it "should attach user statistics to the user" do
      allow(GroupStatisticAttacher).to receive(:attach_statistics)
      user = create(:user)

      GroupCompletion.new(user)

      expect(GroupStatisticAttacher).to have_received(:attach_statistics)
    end
  end


end
