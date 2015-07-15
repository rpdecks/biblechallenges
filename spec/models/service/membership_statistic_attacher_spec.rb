require 'spec_helper'

describe MembershipStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the MembershipStatistics in the system to a membership" do
      membership = create(:membership)
      MembershipStatisticAttacher.attach_statistics(membership)
      expect(membership.membership_statistics.size).to eq MembershipStatistic.descendants.size
    end
    it "should only attach the statistics the membership does not have" do
      membership = create(:membership)
      membership.membership_statistics << MembershipStatisticTotalChaptersRead.create
      MembershipStatisticAttacher.attach_statistics(membership)
      expect(membership.membership_statistics.size).to eq MembershipStatistic.descendants.size
    end
  end


end
