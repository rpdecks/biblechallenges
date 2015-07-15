require 'spec_helper'

describe MembershipStatisticTotalChaptersRead do

  describe "#calculate" do

    it "calculates the total chapters read for a particular membership" do
      user = create(:user)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-4')
      challenge2 = create(:challenge_with_readings, chapters_to_read: 'John 1-3')
      membership = create(:membership, challenge: challenge, user: user)
      create(:membership, challenge: challenge2, user: user)

      # read two chapters in two challenges for this user for a total of 4
      Challenge.all.each do |c|
        c.memberships.each do |m|
          create(:membership_reading, reading: c.readings.first, membership: m)
          create(:membership_reading, reading: c.readings.second, membership: m)
        end
      end

    stat = MembershipStatisticTotalChaptersRead.new(membership: membership)
    expect(stat.calculate).to eq 2  # ignore the other membership
    end
  end
end
