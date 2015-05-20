require 'spec_helper'

describe GroupStatisticProgressPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
      m1 = create(:membership, challenge: challenge, group: group)
      m2 = create(:membership, challenge: challenge, group: group)

      # read 2 / 20 chapters for first member and update stats
      m1.membership_readings[0..1].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      # read 6 / 20 chapters for second member and update stats
      m2.membership_readings[0..5].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      MembershipStatisticProgressPercentage.new(membership: m1).update
      MembershipStatisticProgressPercentage.new(membership: m2).update

      stat = GroupStatisticProgressPercentage.new(group: group)
      expect(stat.calculate).to eq 20  # 8 chapters out of 40 possible
    end
  end
end
