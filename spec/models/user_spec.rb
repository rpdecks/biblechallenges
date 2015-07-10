require 'spec_helper'

describe User do
  describe "Validations" do
    it "has a valid factory" do
      expect(create(:user)).to be_valid
    end

    it { should validate_presence_of :name }
  end

  describe "Relations" do
    it { should have_many(:created_challenges) }
    it { should have_many(:memberships) }
    it { should have_many(:comments) }
    it { should have_many(:badges) }
    it { should have_many(:challenges).through(:memberships)}
    it { should have_many(:groups).through(:memberships)}
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
    describe "#associate_statistics" do
      it "creates named statistics and associates them with new user" do
        user = create(:user)
        user.associate_statistics

        # somehow verify that all the statistics are present
        UserStatistic.descendants.each do |user_stat|
          #user_stat.name will hold the type of each possible membership statistic
          result = user.user_statistics.find_by_type(user_stat.name)
          expect(result).to_not be_nil
        end
      end
    end
  end
end
