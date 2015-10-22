require 'spec_helper'

describe UserStatisticDaysReadInARowAllTime do
  describe "#calculate" do
    it "should calculate the proper value for user reading on consecutive days, even after leaving challenge" do
      challenge = create(:challenge, :with_membership, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user.associate_statistics
      current_stat = user.user_statistics.find_by_type("UserStatisticDaysReadInARowCurrent")
      all_time_stat = user.user_statistics.find_by_type("UserStatisticDaysReadInARowAllTime")

      challenge.readings[0..4].each do |r|
        create(:membership_reading, membership: membership, reading: r, user_id: user.id)
        Timecop.travel(1.day)
      end
      current_stat.update
      all_time_stat.update

      Timecop.travel(1.days) # skip one day

      challenge.readings[5..6].each do |r|
        create(:membership_reading, membership: membership, reading: r, user_id: user.id)
        Timecop.travel(1.day)
      end
      current_stat.update
      all_time_stat.update

      membership.destroy #user leaves challenge
      expect(current_stat.value).to eq 2
      expect(all_time_stat.value).to eq 5
      Timecop.return
    end
  end
end
