require 'spec_helper'
feature 'Group Statistic' do

  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  feature 'User deletes a group' do
    scenario 'Removes the challenge_statistics all together' do
      challenge = create(:challenge, :with_readings)
      group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
      membership = create(:membership, challenge: challenge, user: user, group_id: group.id)
      MembershipCompletion.new(membership)
      GroupCompletion.new(group)
      ChallengeCompletion.new(challenge)

      visit(challenge_path(challenge))
      click_link "Delete Group"

      group_statistic = GroupStatistic.first
      expect(group_statistic).to be_falsey
    end
  end
end
