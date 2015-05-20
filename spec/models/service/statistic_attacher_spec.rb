=begin
require 'spec_helper'

describe StatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the statistics in the system to a user" do
      user = create(:user)
      StatisticAttacher.attach_statistics(user)
      expect(user.statistics.size).to eq Statistic.descendants.size
    end
    it "should only attach the statistics the user does not have" do
      user = create(:user)
      user.statistics << OneChapterBadge.create
      StatisticAttacher.attach_statistics(user)
      expect(user.statistics.size).to eq Statistic.descendants.size
    end
  end


end
=end

