require 'spec_helper'

describe GroupStatisticRecordSequentialReading do

  describe "#calculate" do
    it "should calculate the average of this statistic in the group" do
      membership_1 = instance_double("Membership", membership_statistic_record_reading_streak:
                                     double(value: 1))
      membership_2 = instance_double("Membership", membership_statistic_record_reading_streak: 
                                     double(value: 3))
      group = instance_double("Group", memberships: [membership_1, membership_2])

      stat = GroupStatisticRecordSequentialReading.new
      allow(stat).to receive(:group).and_return(group)

      expect(stat.calculate).to eq 2
    end
  end
end
