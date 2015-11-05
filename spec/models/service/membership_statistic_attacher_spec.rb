require 'spec_helper'

describe MembershipStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the MembershipStatistics in the system to a membership" do
      membership_statistics = double(:membership_statistics, pluck: []).as_null_object
      membership = double(:membership, membership_statistics: membership_statistics)
      allow(MembershipStatistic).to receive(:create)

      MembershipStatisticAttacher.attach_statistics(membership)

      expect(MembershipStatistic).to have_received(:create).exactly(num_membership_statistics).times
    end

    it "should only attach the statistics the membership does not have" do
      membership_statistics = double(:membership_statistics, pluck: [membership_statistics_names.first]).as_null_object
      membership = double(:membership, membership_statistics: membership_statistics)
      allow(MembershipStatistic).to receive(:create)

      MembershipStatisticAttacher.attach_statistics(membership)

      expect(MembershipStatistic).to have_received(:create).exactly(num_membership_statistics - 1).times
    end
  end

  def num_membership_statistics
    MembershipStatistic.descendants.size
  end

  def membership_statistics_names
    MembershipStatistic.descendants.map(&:name)
  end
end
