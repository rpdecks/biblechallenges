require 'spec_helper'

describe MembershipReading do
  
  describe "Validations" do

    it "has a valid factory" do
      expect(create(:membership_reading)).to be_valid
    end

    it { should validate_presence_of(:reading_id) }
    it { should validate_presence_of(:membership_id) }
    it { should ensure_inclusion_of(:state).in_array(MembershipReading::STATES)}
  end

  describe "Relations" do
    it { should belong_to(:membership) }
    it { should belong_to(:reading) }
  end


  describe "Callbacks" do
    describe "Before save" do
      describe "#punctual?" do
          it "will record the membership_reading as punctual" do
            pending
            Timecop.travel(5.days.ago)
            challenge = create(:challenge_with_readings)
            challenge.generate_readings
            user = User.first
            membership = challenge.join_new_member(user)
            Timecop.return
            Timecop.travel(4.days.ago)
            membership_reading = membership.membership_readings.first
            membership_reading.update_attributes(state: "read")
            Timecop.return
            Timecop.travel(3.days.ago)
            membership_reading = membership.membership_readings.second
            membership_reading.update_attributes(state: "read")
            Timecop.return
            membership_reading = membership.membership_readings.third
            membership_reading.update_attributes(state: "read")
            expect(membership.membership_readings.first.punctual).to eq 1
            expect(membership.membership_readings.second.punctual).to eq 1
            expect(membership.membership_readings.third.punctual).to eq 0
          end
      end
    end
  end

end
