require 'spec_helper'

feature 'User manages member/challenge' do
  let(:user) {create(:user, :with_profile)}

  before(:each) do
    login(user)
  end

  scenario 'User is able to see Todays reading', :js => true do
    pending "TODO: how to test content within javascript"
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    expect(page).to have_content("David")
  end

  scenario 'User is able to log todays reading' do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    click_link 'Log my reading'
    expect(MembershipReading.count).to eq 1
  end
end
