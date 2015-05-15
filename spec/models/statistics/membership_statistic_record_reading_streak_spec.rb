require 'spec_helper'

describe MembershipStatisticRecordReadingStreak do
  describe "#calculate" do
    it "should calculate the proper value" do
      Timecop.travel(6.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)
      membership.membership_readings[0..1].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      Timecop.return
      Timecop.travel(3.days.ago)
      membership.membership_readings[2].update_attributes(state: "read")
      Timecop.return
      Timecop.travel(2.days.ago)
      membership.membership_readings[3].update_attributes(state: "read")
      Timecop.return
      membership.membership_readings[4].update_attributes(state: "read")
      membership.membership_readings[5].update_attributes(state: "read")

      stat = MembershipStatisticRecordReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 2
    end
  end

end
