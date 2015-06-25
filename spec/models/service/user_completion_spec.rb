require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe UserCompletion do

  describe "Badges" do
    it "should attach badges to the user" do
      allow(BadgeAttacher).to receive(:attach_badges)
      user = create(:user)

      UserCompletion.new(user)

      expect(BadgeAttacher).to have_received(:attach_badges)
    end
  end

  describe "UserStatistics" do
    it "should attach user statistics to the user" do
      allow(UserStatisticAttacher).to receive(:attach_statistics)
      user = create(:user)

      UserCompletion.new(user)

      expect(UserStatisticAttacher).to have_received(:attach_statistics)
    end
  end

  describe "Profile" do
    it "should attach a profile to the user" do
      allow(ProfileAttacher).to receive(:attach_profile)
      user = create(:user)

      UserCompletion.new(user)

      expect(ProfileAttacher).to have_received(:attach_profile)
    end
  end

end
