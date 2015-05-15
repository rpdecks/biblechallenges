require 'spec_helper'

describe UserCompletion do

  describe "Badges" do
    it "should attach badges to the user" do
      allow(BadgeAttacher).to receive(:attach_badges)
      user = create(:user)

      UserCompletion.new(user)

      expect(BadgeAttacher).to have_received(:attach_badges)
    end
  end

=begin  describe "Statistics" do
    it "should attach statistics to the user" do
      allow(StatisticAttacher).to receive(:attach_statistics)
      user = create(:user)

      UserCompletion.new(user)

      expect(StatisticAttacher).to have_received(:attach_statistics)
    end
  end
=end

end
