require 'spec_helper'
feature 'Challenge Statistic' do

  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  feature 'Owner deletes the challenge' do
    scenario 'Removes the challenge_statistics all together' do
      challenge = create(:challenge, owner_id: user.id)
      ChallengeCompletion.new(challenge)
      create(:membership, :with_statistics, challenge: challenge, user: user)
      visit creator_challenge_path(challenge)
      click_link "Delete"
      membership_statistic = ChallengeStatistic.first
      expect(membership_statistic).to be_falsey
    end
  end
end
