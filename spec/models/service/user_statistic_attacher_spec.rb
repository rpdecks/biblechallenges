require 'spec_helper' 
describe UserStatisticAttacher do

  describe "#attach_statistics" do
    it "should attach all the UserStatistics in the system to a user" do
      user_statistics = double(:user_statistics, pluck: []).as_null_object
      user = double(:user, user_statistics: user_statistics)
      allow(UserStatistic).to receive(:create)

      UserStatisticAttacher.attach_statistics(user)

      expect(UserStatistic).to have_received(:create).exactly(num_of_user_statistics).times
    end

    it "should only attach the statistics the user does not have" do
      user_statistics = double(:user_statistics, pluck: [user_statistics_names.first]).as_null_object
      user = double(:user, user_statistics: user_statistics)
      allow(UserStatistic).to receive(:create)

      UserStatisticAttacher.attach_statistics(user)

      expect(UserStatistic).to have_received(:create).exactly(num_of_user_statistics - 1).times
    end
  end

  def user_statistics_names
    UserStatistic.descendants.map(&:name)
  end

  def num_of_user_statistics
    UserStatistic.descendants.size
  end
end
