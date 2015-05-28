require 'spec_helper'

describe Reading do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:reading)).to be_valid
    end

    it { should validate_presence_of(:chapter_id) }
    it { should validate_presence_of(:challenge_id) }
    it { should validate_presence_of(:date) }
  end

  describe "Delegations" do
    it { should delegate_method(:owner).to(:challenge) }
  end

  describe "Relations" do
    it { should belong_to(:challenge) }
    it { should belong_to(:chapter) }
    it { should have_many(:memberships).through(:membership_readings) }
    it { should have_many(:membership_readings) }
  end

  describe "Scopes" do

    describe "to_date" do
      let!(:challenge){create(:challenge, chapters_to_read: 'Mar 1 -7')}
      let(:membership){create(:membership, challenge: challenge)}

      it "should find all readings up to and including the passed date" do
        challenge.generate_readings
        expect(membership.readings.to_date(challenge.begindate + 1.day)).to have(2).items
      end
    end
  end

  describe "Instance Methods" do
    describe "last_readers" do
      it "should return a collection of the last x readers" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1 -2')
        challenge.generate_readings
        reading = challenge.readings.first
        m1 = create(:membership, challenge: challenge)
        m2 = create(:membership, challenge: challenge)
        create(:membership_reading, reading: reading, membership: m1)
        create(:membership_reading, reading: reading, membership: m2)
        expect(reading.last_readers(2)).to match_array [m1.user, m2.user]
        
      end

      it "should return an empty collection of noone has read" do
        challenge = create(:challenge, chapters_to_read: 'Mar 1 -2')
        challenge.generate_readings
        reading = challenge.readings.first
        create(:membership, challenge: challenge)
        create(:membership, challenge: challenge)
        expect(reading.last_readers(2)).to match_array []
      end
    end
  end
end
