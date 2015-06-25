require 'spec_helper'

describe ChallengeStatisticProgressPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-10')
      m1 = challenge.owner.memberships.first  #creator/owner is also the first memeber of the challenge
      m2 = create(:membership, challenge: challenge)

      # read 4 / 10 chapters for first member
      challenge.readings[0..3].each do |r|
        create(:membership_reading, membership: m1, reading: r)
      end

      # read 6 / 10 chapters for second member and update stats
      challenge.readings[0..5].each do |r| # read first two
        create(:membership_reading, membership: m2, reading: r)
      end
      MembershipStatisticProgressPercentage.new(membership: m1).update
      MembershipStatisticProgressPercentage.new(membership: m2).update

      stat = ChallengeStatisticProgressPercentage.new(challenge: challenge)
      expect(stat.calculate).to eq 50  # 10 chapters out of 20 possible
    end
  end
end
