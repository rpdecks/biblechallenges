require 'spec_helper'

describe UserStatisticChaptersReadAllTime do
  describe "#calculate" do
    it "should calculate the proper value for current user" do
      challenge = create(:challenge, :with_membership, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticChaptersReadAllTime.new(user: user)
      challenge.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
      end

      expect(user_stat.value.to_i).to eq 4
    end

    it "should calculate the proper value for user with multiple memberships_readings" do
      challenge1 = create(:challenge, :with_membership, chapters_to_read: 'Mark 1-7')
      user = challenge1.members.first
      membership = challenge1.memberships.first
      challenge1.generate_readings
      user_stat = UserStatisticChaptersReadAllTime.new(user: user)
      challenge1.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
      end

      challenge2 = create(:challenge, :with_membership, chapters_to_read: 'Matt  1-7', owner: user)
      membership2 = challenge2.memberships.first
      challenge2.generate_readings
      challenge2.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership2, reading: mr)
        user_stat.update
      end

      expect(user_stat.value.to_i).to eq 8
    end
  end
end
