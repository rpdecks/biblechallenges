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

    it { should have_many(:users).through(:user_readings) }
    it { should have_many(:user_readings) }
  end

end