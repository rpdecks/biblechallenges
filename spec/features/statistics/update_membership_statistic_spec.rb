require 'spec_helper'
feature 'Membership Statistic' do

  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  feature 'User leaves challenge' do
    scenario 'Removes the membership_statistics all together' do
      challenge = create(:challenge, :with_readings)
      visit challenge_path(challenge)
      click_link "Join Challenge"
      visit challenge_path(challenge)
      click_link "Unsubscribe"
      membership_statistic = MembershipStatistic.first
      expect(membership_statistic).to be_falsey
    end
  end

  feature 'Owner deletes the challenge' do
    scenario 'Removes the membership_statistics all together' do
      challenge = create(:challenge, owner_id: user.id)
      user2 = create(:user)
      membership1 = create(:membership, challenge: challenge, user: user)
      membership2 = create(:membership, challenge: challenge, user: user2)
      MembershipCompletion.new(membership1)
      MembershipCompletion.new(membership2)
      visit edit_creator_challenge_path(challenge)
      click_link "Delete"
      membership_statistic = MembershipStatistic.first
      expect(membership_statistic).to be_falsey
    end
  end
end
