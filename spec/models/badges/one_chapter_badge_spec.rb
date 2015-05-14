require 'spec_helper'

RSpec.describe OneChapterBadge, type: :model do

  describe "Instance Methods" do
    describe "#qualify?" do
      it "returns false if the user has not read more than one chapter" do
        user = create(:user)
        challenge = create(:challenge_with_readings)
        create(:membership, challenge: challenge, user: user)
        ocb = OneChapterBadge.create(user: user)

        expect(ocb.qualify?).to eq false
      end
      it "returns true if the user read more than one chapter" do
        user = create(:user)
        challenge = create(:challenge_with_readings)
        create(:membership, challenge: challenge, user: user)
        ocb = OneChapterBadge.create(user: user)
        user.membership_readings.first.update_attributes(state: "read")

        expect(ocb.qualify?).to eq true
      end
    end
  end
end

