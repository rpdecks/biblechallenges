require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe UserCompletion do
  describe "Attach badges and statistics" do
    it "should attach badges and statistics to the user" do
      badges = double(:badges, pluck: []).as_null_object
      user = double(:user, badges: badges).as_null_object
      allow(BadgeAttacher).to receive(:attach_badges)
      allow(UserStatisticAttacher).to receive(:attach_statistics)

      UserCompletion.new(user)

      expect(BadgeAttacher).to have_received(:attach_badges)
      expect(UserStatisticAttacher).to have_received(:attach_statistics)
    end
  end
end
