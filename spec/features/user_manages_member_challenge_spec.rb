require 'spec_helper'

feature 'User manages member/challenge' do
  let(:user) {create(:user, :with_profile)}
  let(:challenge) {create(:challenge_with_readings)}

  before(:each) do
    login(user)
  end

  scenario 'User is able to see Todays reading' do
    membership = create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    membership.readings.to_date(Date.today).first.chapter.verses.by_version(membership.bible_version).each do |v|
      expect(page).to have_content(v.versetext)
    end
  end
end
