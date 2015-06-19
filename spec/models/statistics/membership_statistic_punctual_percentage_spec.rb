require 'spec_helper'

describe MembershipStatisticOnSchedulePercentage do

  describe "#calculate" do

    it "should calculate a perfect percentage" do
      # four chapters each read on the right day
      start_date = Date.today
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: 'Matt 1-4', begindate: start_date)

      membership = create(:membership, challenge: challenge)
      readings = challenge.readings
      create(:membership_reading, reading: readings[0], membership: membership, updated_at: start_date)
      create(:membership_reading, reading: readings[1], membership: membership, updated_at: start_date + 1)
      create(:membership_reading, reading: readings[2], membership: membership, updated_at: start_date + 2)
      create(:membership_reading, reading: readings[3], membership: membership, updated_at: start_date + 3)


      Timecop.travel(3.days)

      stat = MembershipStatisticOnSchedulePercentage.new(membership: membership)
      expect(stat.calculate).to eq 100
      Timecop.return
    end
  end

end
