require 'spec_helper'

describe MembershipReading do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:membership_reading)).to be_valid
    end

    it { should validate_presence_of(:reading_id) }
    it { should validate_presence_of(:membership_id) }

  end

  describe "Relations" do
    it { should belong_to(:membership) }
    it { should belong_to(:reading) }
  end



  describe "Scopes" do
    describe "#last_week" do
      it "returns membership readings that were logged/created within the last 8 days" do
        Timecop.travel(10.days.ago)
        challenge = create(:challenge_with_readings)
        challenge.generate_readings
        user = User.first
        membership = challenge.join_new_member(user)
        create_list(:membership_reading, 3, membership: membership)
        Timecop.return
        Timecop.travel(7.days.ago)
        create_list(:membership_reading, 2, membership: membership)
        Timecop.return
        Timecop.travel(2.days.ago)
        create_list(:membership_reading, 1, membership: membership)

        expect(challenge.membership_readings.size).to eq 6
        expect(challenge.membership_readings.last_week.size).to eq 3
      end
    end
  end

  describe " methods" do
    describe "#most_recent" do
      it "returns the most recent recorded reading time" do
        newest_reading = create(:membership_reading)
        create(:membership_reading, created_at: 3.days.ago)
        membership_readings = MembershipReading.all
        expect(membership_readings.most_recent).to eq newest_reading
      end

      it "returns NoReading class when none is present" do
        result = MembershipReading.most_recent

        expect(result).to be_a(NoReading)
      end

      it "returns no reading text when user has no membership reading" do
        membership = create(:membership)
        result = membership.last_recorded_reading_time
        expect(result).to eq MembershipReading::NO_READING
      end
    end
  end

end

