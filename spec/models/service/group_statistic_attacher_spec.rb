require 'spec_helper'

describe GroupStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the GroupStatistics in the system to a group" do
      group = create(:group, challenge: create(:challenge))
      GroupStatisticAttacher.attach_statistics(group)
      expect(group.group_statistics.size).to eq GroupStatistic.descendants.size
    end
    it "should only attach the statistics the group does not have" do
      group = create(:group, challenge: create(:challenge))
      group.group_statistics << GroupStatisticTotalChaptersRead.create
      GroupStatisticAttacher.attach_statistics(group)
      expect(group.group_statistics.size).to eq GroupStatistic.descendants.size
    end
  end


end
