require 'spec_helper'

describe BadgeAttacher do

  describe "#attach_badges" do
    it "should attach all the Badges in the system to a user" do
      badges = double(:badge, pluck: []).as_null_object
      user =  double(:user, badges: badges)
      allow(Badge).to receive(:create)

      BadgeAttacher.attach_badges(user)

      expect(Badge).to have_received(:create).exactly(num_of_badges).times
    end

    it "should only attach the Badges the user does not have" do
      badges = double(:badge, pluck: [badge_names.first]).as_null_object
      user = double(:user, badges: badges)
      allow(Badge).to receive(:create)

      BadgeAttacher.attach_badges(user)
      expect(Badge).to have_received(:create).exactly(num_of_badges - 1).times
    end
  end

  def num_of_badges
    Badge.descendants.size
  end

  def badge_names
    Badge.descendants.map(&:name)
  end
end
