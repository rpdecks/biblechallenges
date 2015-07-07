require 'spec_helper'

describe ChallengeStatisticOnSchedulePercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      start_date = Date.today
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-10', begindate: start_date)
      readings = challenge.readings
      m1 = challenge.owner.memberships.first  #creator/owner is also the first memeber of the challenge
      m2 = create(:membership, challenge: challenge)
      m3 = create(:membership, challenge: challenge)

      readings[0..2].each do |r|
        create(:membership_reading, membership: m1, reading:r)
        create(:membership_reading, membership: m2, reading:r)
        create(:membership_reading, membership: m3, reading:r)
        Timecop.travel(1.day) # each member read 3 chapters on-schedule, 9 readings
      end
      readings[3..5].each do |r|
        create(:membership_reading, membership: m1, reading:r)
        Timecop.travel(1.day)
        # read 12 / 18 membership readings are on-schedule
      end
      # todo this is because of the callback on membership stats when you create a challenge yuck
      m1.update_stats
      MembershipStatisticOnSchedulePercentage.new(membership: m2).update
      MembershipStatisticOnSchedulePercentage.new(membership: m3).update
      stat = ChallengeStatisticOnSchedulePercentage.new(challenge: challenge)
      expect(stat.calculate).to eq 66  # 12 on-schedule out of 18
    end
  end
end
