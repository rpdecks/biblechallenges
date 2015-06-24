require 'spec_helper'

describe GroupStatisticAverageOnSchedulePercentage do

  describe "#calculate" do
    it "should calculate the average onschedule percentage for the group" do
      start_date = Date.today
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: 'Matt 1-10', begindate: start_date)

      group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
      readings = challenge.readings
      m1 = create(:membership, challenge: challenge, group: group)
      m2 = create(:membership, challenge: challenge, group: group)


      # read 2 / 10 chapters on scheduled days for member 1
      create(:membership_reading, reading: readings[0], membership: m1, updated_at: start_date)
      create(:membership_reading, reading: readings[1], membership: m1, updated_at: start_date + 1.day)

      # read 2 / 10 chapters not on scheduled days for member 2
      create(:membership_reading, reading: readings[0], membership: m2, updated_at: start_date)
      create(:membership_reading, reading: readings[1], membership: m2, updated_at: start_date)

      Timecop.travel(2.days) #day 3
      MembershipStatisticOnSchedulePercentage.new(membership: m1).update
      MembershipStatisticOnSchedulePercentage.new(membership: m2).update

      group_stat = GroupStatisticAverageOnSchedulePercentage.new(group: group)
      expect(group_stat.calculate).to eq 75
      Timecop.return
    end
  end
end
