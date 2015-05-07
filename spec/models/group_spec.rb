require 'spec_helper'

RSpec.describe Group, type: :model do
  describe "Relations" do
    it { should belong_to(:challenge)} 
    it { should belong_to(:user)} 
    it { should have_many(:memberships)} 
  end

  describe "#group_punctual_reading_percentage" do
    it "returns the average percentage of time the readers in the group read according to schedule" do
        Timecop.travel(4.days.ago)
        challenge = create(:challenge, chapters_to_read: 'Matt 1-20')
        membership = create(:membership, challenge: challenge)
        membership2 = create(:membership, challenge: challenge, user: User.first)
        group = challenge.groups.create(name: "UC Irvine", user_id: User.first.id)
        membership.update_attributes(group_id: group.id)
        membership2.update_attributes(group_id: group.id)
        membership.membership_readings[0..1].each do |mr| # read first two
          mr.state = 'read'
          mr.save!
        end
        Timecop.return
        Timecop.travel(3.days.ago)
        membership2.membership_readings.first.update_attributes(state: "read")
        Timecop.return
        Timecop.travel(2.days.ago)
        membership2.membership_readings.second.update_attributes(state: "read")
        Timecop.return
        Timecop.travel(1.days.ago)
        membership.membership_readings.third.update_attributes(state: "read")
        membership2.membership_readings.third.update_attributes(state: "read")
        Timecop.return
        expect(group.punctual_reading_percentage_average).to eq 50
    end
  end



end
