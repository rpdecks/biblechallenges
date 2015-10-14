require 'spec_helper'

describe MembershipGenerator do
  describe "#generate_membership" do
    it "creates membership for multiple users" do
      users = create_list(:user, 3)
      challenge = create(:challenge)
      MembershipGenerator.new(challenge, users).generate
      expect(Membership.count).to eq 3
    end

    it "creates membership for one user" do
      user = create(:user)
      challenge = create(:challenge)
      MembershipGenerator.new(challenge, user).generate
      expect(Membership.count).to eq 1
    end
  end
end
