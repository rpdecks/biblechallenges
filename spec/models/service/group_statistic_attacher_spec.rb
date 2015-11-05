require 'spec_helper'

describe GroupStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the GroupStatistics in the system to a group" do
      group_statistics = double(:group_statistics, pluck: []).as_null_object
      group = double(:group, group_statistics: group_statistics)
      allow(GroupStatistic).to receive(:create)

      GroupStatisticAttacher.attach_statistics(group)

      expect(GroupStatistic).to have_received(:create).exactly(num_group_statistics).times
    end

    it "should only attach the statistics the group does not have" do
      group_statistics = double(:group_statistics, pluck: [group_statistics_names.first]).as_null_object
      group = double(:group, group_statistics: group_statistics)
      allow(GroupStatistic).to receive(:create)

      GroupStatisticAttacher.attach_statistics(group)

      expect(GroupStatistic).to have_received(:create).exactly(num_group_statistics - 1).times
    end
  end

  def num_group_statistics
    GroupStatistic.descendants.size
  end

  def group_statistics_names
    GroupStatistic.descendants.map(&:name)
  end
end
