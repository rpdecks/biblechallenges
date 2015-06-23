require 'spec_helper'

describe UserStatisticDaysReadInARowCurrent do
  describe "#update" do
    it "should calculate the proper value for user reading on consecutive days" do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticDaysReadInARowCurrent.new(user: user)
      challenge.readings[0..4].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

        Timecop.return
      expect(user_stat.value.to_i).to eq 5
    end

    it "calculates  " do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-10')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticDaysReadInARowCurrent.new(user: user)
      challenge.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

      Timecop.travel(1.day) #skip one day
      challenge.readings[4..8].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

      expect(user_stat.value.to_i).to eq 5
      Timecop.return
    end
  end
end
