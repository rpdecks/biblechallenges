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
        expect(membership.readings.to_date(challenge.begindate + 1.day)).to have(2).items
      end
    end
  end
end
