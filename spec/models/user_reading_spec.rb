require 'spec_helper'

describe UserReading do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:user_reading)).to be_valid
    end

    it { should validate_presence_of(:reading_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:reading) }
  end
end