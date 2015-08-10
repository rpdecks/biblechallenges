require 'spec_helper'

feature 'Nonuser visits BibleChallenges' do
  feature "From the group page" do
    scenario 'Visits group page within a challenge successfully' do
      user = create(:user)
      challenge = create(:challenge)
      challenge.groups.create(name: "My group", user: user)
      visit challenge_path(challenge)

      expect(page).to have_content("My group")
    end

    scenario 'Nonuser visits group page and tries to join a group' do
      user = create(:user)
      challenge = create(:challenge)
      challenge.groups.create(name: "My group", user_id: user.id, challenge_id: challenge.id)
      visit challenge_path(challenge)
      click_link "Sign me up"

      expect(page).to have_content("Create a Bible Challenges Account")
    end
  end

  feature "From the challenge page" do
    scenario 'Nonuser visits challenge show page and cannot see create group link' do
      user = create(:user)
      challenge = create(:challenge)
      challenge.groups.create(name: "My group", user: user)
      visit challenge_path(challenge)
      expect(page).not_to have_content("Create a group")
    end

  end
end
