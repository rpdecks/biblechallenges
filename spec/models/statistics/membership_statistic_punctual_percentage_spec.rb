require 'spec_helper'

describe MembershipStatisticPunctualPercentage do
  describe "#calculate" do
    it "should calculate the proper value" do
      Timecop.travel(4.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)
      membership.membership_readings[0..1].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      Timecop.return
      Timecop.travel(1.days.ago)
      membership.membership_readings.third.update_attributes(state: "read")
      Timecop.return

      stat = MembershipStatisticPunctualPercentage.new(membership: membership)
      expect(stat.calculate).to eq 25
    end
  end

end
