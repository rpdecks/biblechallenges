require 'spec_helper'

feature 'User updates membership preferences' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User should see the Change (Bible Version) Link if he is a member of challenge' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenges_path
    click_link challenge.name
    click_link "Details"

    expect(page).to have_content("Change")
  end

  scenario 'Member of challenge can visit profile update page for bible_version directly from challenge page' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenges_path
    click_link challenge.name
    click_link "Details"
    click_link "Change"

    expect(page).to have_button("Update my Challenge Settings")
  end

  scenario 'Member of challenge should be able to edit their Bible version pref' do
    challenge = create(:challenge)
    create(:membership, bible_version: "KJV", challenge: challenge, user: user)
    visit member_challenges_path
    click_link challenge.name
    click_link "Details"
    click_link "Change"

    select 'ESV', from: "Preferred Bible Version"
    click_button "Update my Challenge Settings"

    expect(user.memberships.first.bible_version).to eq "ESV"
  end


end
