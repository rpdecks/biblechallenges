require 'spec_helper'

RSpec.describe Badge, type: :model do
  describe "associations" do
    it {should belong_to(:user) }
  end

  describe "sandbox" do

    it "should see if a given user qualifies for various badges" do
      # create a user who has joined a challenge
      user = create(:user)
      challenge = create(:challenge_with_readings)
      Badge.update_user_badges(user)

      expect(user.badges.find_by_type("JoinChallengeBadge").granted).to be false
      expect(user.badges.find_by_type("OneChapterBadge").granted).to be false

      membership = create(:membership, challenge: challenge, user: user)
      Badge.update_user_badges(user)
      expect(user.badges.find_by_type("JoinChallengeBadge").granted).to be true
      expect(user.badges.find_by_type("OneChapterBadge").granted).to be false

      # check off a reading
      user.membership_readings.first.update_attributes(state: "read")
      Badge.update_user_badges(user)
      expect(user.badges.find_by_type("OneChapterBadge").granted).to be true









    end








  end




end
