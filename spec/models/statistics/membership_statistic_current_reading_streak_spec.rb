require 'spec_helper'

describe MembershipStatisticCurrentReadingStreak do
  describe "#calculate" do
    it "should calculate the proper value" do
      Timecop.travel(6.days.ago)
      challenge = create(:challenge_with_readings, begindate: Date.today, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      Timecop.return

      membership.membership_readings[0].update_attributes(state: "read", updated_at: 6.days.ago)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: 6.days.ago)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: 6.days.ago)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: 6.days.ago)

      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 2
    end

    it "testing timecop" do
      challenge = create(:challenge_with_readings, begindate: Date.today, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)

      Timecop.travel(3.days.ago)
      membership.membership_readings[0..1].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      Timecop.return
      binding.pry

    end
  end

end

