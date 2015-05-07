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

end
