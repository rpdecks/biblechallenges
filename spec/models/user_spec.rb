require 'spec_helper'

describe User do

  describe "Validations" do

    it "has a valid factory" do
      expect(create(:user)).to be_valid
    end
  end

  describe "Relations" do
    it { should have_many(:created_challenges) }
    it { should have_many(:memberships) }
    it { should have_many(:comments) }
    it { should have_many(:badges) }
    it { should have_many(:challenges).through(:memberships)}
    it { should have_many(:groups).through(:memberships)}
  end

  describe "Callbacks" do

    it "deletes the user profile on user deletion" do
      current_user = FactoryGirl.create(:user)
      expect { current_user.destroy }.to change(Profile, :count).by(-1)
    end
  end

  describe "Instance Methods" do
    describe "#find_challenge_group" do
      it "finds the users group for a given challenge" do
        u = create(:user)
        c = create(:challenge)
        g = create(:group, challenge: c, user: create(:user))
        create(:membership, challenge: c, user: u, group: g)

        expect(u.find_challenge_group(c)).to eq g
      end

    end
  end

end
