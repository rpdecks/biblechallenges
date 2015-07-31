require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'Owner of challenge changes the name of the challenge after the challenge has been created' do
    challenge = create(:challenge, owner_id: user.id, name: "Awesome")
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    click_link 'Edit Challenge'
    fill_in 'Challenge Name', with: "Wonderful"
    click_button 'Update'
    expect(page).to have_content("Successfully updated challenge")
    challenge.reload
    expect(challenge.name).to eq "Wonderful"
  end
end
