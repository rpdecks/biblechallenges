require 'spec_helper'

describe MembershipStatisticPunctualPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
        Timecop.travel(6.days.ago)
        challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
        group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
        membership = create(:membership, challenge: challenge)
        membership2 = create(:membership, challenge: challenge, user: User.first)
        membership.update_attributes(group_id: group.id)
        membership2.update_attributes(group_id: group.id)

        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        membership2.membership_readings[0].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(4.days.ago)
        membership2.membership_readings[1].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(3.days.ago)
        membership.membership_readings[2].update_attributes(state: "read")
        membership2.membership_readings[2].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(2.days.ago)
        membership.membership_readings[3].update_attributes(state: "read")
        membership2.membership_readings[3].update_attributes(state: "read")
        Timecop.return
        Timecop.travel(1.days.ago)
        membership2.membership_readings[4].update_attributes(state: "read")
        Timecop.return
        membership.membership_readings[4].update_attributes(state: "read")
        membership.membership_readings[5].update_attributes(state: "read")
        membership2.membership_readings[5].update_attributes(state: "read")

        expect(membership2.punctual_reading_percentage).to eq 83
        binding.pry
        stat = MembershipStatisticPunctualPercentage.new(membership: membership)
        expect(stat.calculate).to eq 83

    end
  end
end
