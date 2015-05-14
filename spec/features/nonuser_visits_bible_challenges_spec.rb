require 'spec_helper'

feature 'Nonuser visits BibleChallenges' do
  scenario 'Visits group page within a challenge' do
    user = create(:user)
    challenge = create(:challenge)
    challenge.groups.create(name: "My group", user: user)
    visit challenge_path(challenge)
    click_link "My group"

    expect(page).to have_content("My group")
  end

  scenario 'Nonuser visits group page and Joins a Group' do
    user = create(:user)
    challenge = create(:challenge)
    challenge.groups.create(name: "My group", user_id: user.id, challenge_id: challenge.id)
    visit challenge_path(challenge)
    click_link "My group"
    click_link "Sign me up"

    expect(page).to have_content("Create a Bible Challenges Account")
  end
end
