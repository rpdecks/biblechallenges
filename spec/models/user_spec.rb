require 'spec_helper'

describe User do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:user)).to be_valid
    end

  end

  describe "Relations" do
    it { should have_many(:createdchallenges) }
    it { should have_many(:memberships) }
    it { should have_many(:challenges).through(:memberships)}
  end

end