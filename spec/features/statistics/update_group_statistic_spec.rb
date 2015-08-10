require 'spec_helper'
feature 'Group Statistic' do

  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  feature 'User deletes a group' do
    scenario 'Removes the challenge_statistics all together' do
      challenge = create(:challenge)
      membership = create(:membership, challenge: challenge, user: user)
      MembershipCompletion.new(membership)
      group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
      GroupCompletion.new(group)

      visit(challenge_path(challenge))
      click_link "Delete Group"

    end
  end
end
