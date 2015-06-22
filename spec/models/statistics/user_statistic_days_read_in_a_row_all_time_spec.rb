require 'spec_helper'

describe UserStatisticDaysReadInARowAllTime do
  describe "#calculate" do
    it "should calculate the proper value for user reading on consecutive days" do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticDaysReadInARowAllTime.new(user: user)
      challenge.readings[0..4].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        Timecop.travel(1.day)
        user_stat.update
      end
      Timecop.travel(2.days)
      challenge.readings[5..6].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        Timecop.travel(1.day)
        user_stat.update
      end

      expect(user_stat.value.to_i).to eq 5
    end
  end
end
