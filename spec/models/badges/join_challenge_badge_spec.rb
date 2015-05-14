require 'spec_helper'

RSpec.describe JoinChallengeBadge, type: :model do

  describe "Instance Methods" do
    describe "#qualify?" do
      it "returns false if the user has joined a challenge" do
        user = create(:user)
        badge = JoinChallengeBadge.create(user: user)

        expect(badge.qualify?).to eq false
      end
      it "returns true if the user has joined a challenge" do
        user = create(:user)
        badge = JoinChallengeBadge.create(user: user)
        challenge = create(:challenge_with_readings)
        create(:membership, challenge: challenge, user: user)

        expect(badge.qualify?).to eq true
      end
    end
  end
end

