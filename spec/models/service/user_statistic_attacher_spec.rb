require 'spec_helper'

describe UserStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the UserStatistics in the system to a user" do
      user = create(:user)
      UserStatisticAttacher.attach_statistics(user)
      expect(user.user_statistics.size).to eq UserStatistic.descendants.size
    end
    it "should only attach the statistics the user does not have" do
      user = create(:user)
      user.user_statistics << UserStatisticChaptersReadAllTime.create
      UserStatisticAttacher.attach_statistics(user)
      expect(user.user_statistics.size).to eq UserStatistic.descendants.size
    end
  end


end
