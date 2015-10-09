require 'spec_helper'

describe MembershipGenerator do
  describe "#generate_membership" do
    it "creates membership for one or more users" do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      MembershipGenerator.new(user1, user2, user3)
      expect(Membership.count).to eq 3
    end
  end
end
