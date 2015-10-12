require 'spec_helper'

describe MembershipGenerator do
  describe "#generate_membership" do
    it "creates membership for one or more users" do
      users = create_list(:user, 3)
      challenge = create(:challenge)
      MembershipGenerator.new(challenge, users).generate
      expect(Membership.count).to eq 3
    end
  end
end
