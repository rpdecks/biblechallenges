require 'spec_helper'

describe BadgeAttacher do

  describe "#attach_badges" do
    it "should attach all the Badges in the system to a user" do
      user = create(:user)
      BadgeAttacher.attach_badges(user)
      expect(user.badges.size).to eq Badge.descendants.size
    end
    it "should only attach the Badges the user does not have" do
      user = create(:user)
      user.badges << OneChapterBadge.create
      BadgeAttacher.attach_badges(user)
      expect(user.badges.size).to eq Badge.descendants.size
    end
  end


end
