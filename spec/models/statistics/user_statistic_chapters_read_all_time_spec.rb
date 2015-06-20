require 'spec_helper'

describe UserStatisticChaptersReadAllTime do
  describe "#calculate" do
    it "should calculate the proper value for current user" do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      challenge.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
      end

      user_stat = UserStatisticChaptersReadAllTime.new(user: user)
      expect(user_stat.calculate).to eq 4
    end

    it "should calculate the proper value for user with multiple memberships_readings" do
      challenge1 = create(:challenge, chapters_to_read: 'Mark 1-7')
      user = challenge1.members.first
      membership = challenge1.memberships.first
      challenge1.generate_readings
      challenge1.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
      end

      challenge2 = create(:challenge, chapters_to_read: 'Matt  1-7', owner: user)
      membership2 = challenge2.memberships.first
      challenge2.generate_readings
      challenge2.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership2, reading: mr)
      end

      user_stat = UserStatisticChaptersReadAllTime.new(user: user)
      expect(user_stat.calculate).to eq 8
    end

    #it "should update the proper value for user even if user leaves a challenge" do
    #  challenge = create(:challenge, chapters_to_read: 'Mark 1-7')
    #  user = challenge.members.first
    #  membership = challenge.memberships.first
    #  challenge.generate_readings
    #  challenge.readings[0..3].each do |mr|
    #    create(:membership_reading, membership: membership, reading: mr)
    #  end
    #  
    #  membership.destroy

    #  user_stat = UserStatisticChaptersReadAllTime.new(user: user)
    #  user_stat.update
    #  expect(user_stat.value).to eq 4
    #end
  end
end
