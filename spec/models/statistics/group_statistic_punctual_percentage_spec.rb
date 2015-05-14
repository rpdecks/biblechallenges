require 'spec_helper'

describe GroupStatisticPunctualPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      Timecop.travel(4.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)
      membership2 = create(:membership, challenge: challenge, user: User.first)
      group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
      membership.update_attributes(group_id: group.id)
      membership2.update_attributes(group_id: group.id)
      membership.membership_readings[0..1].each do |mr| # read first two
        mr.state = 'read'
        mr.save!
      end
      Timecop.travel(1.day)
      membership2.membership_readings.first.update_attributes(state: "read")
      Timecop.travel(1.day)
      membership2.membership_readings.second.update_attributes(state: "read")
      Timecop.travel(1.day)
      membership.membership_readings.third.update_attributes(state: "read")
      membership2.membership_readings.third.update_attributes(state: "read")
      Timecop.return

      MembershipStatisticPunctualPercentage.new(membership: membership).update
      MembershipStatisticPunctualPercentage.new(membership: membership2).update

      stat = GroupStatisticPunctualPercentage.new(group: group)
      expect(stat.calculate).to eq 50  # 8 chapters out of 40 possible
    end
  end
end
