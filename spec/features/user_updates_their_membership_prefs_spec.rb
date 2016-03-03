require 'spec_helper'

feature 'User updates membership preferences' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User should see the Change (Bible Version) Link if he is a member of challenge' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)

    expect(page).to have_link("Change")
  end

  scenario 'Member of challenge can visit user profile update page for bible_version directly from challenge page' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    click_link "Change"

    expect(page).to have_button("Update User")
  end

  scenario 'Member of challenge should be able to edit their Bible version pref' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user_kjv)

    expect(user.bible_version).to eq 'KJV'

    visit edit_user_path
    select 'ESV', from: "Preferred Bible Version"
    click_button "Update User"

    expect(user.reload.bible_version).to eq "ESV"
  end

  def user_kjv
    user.update_attributes(bible_version: "KJV")
    user
  end


end
