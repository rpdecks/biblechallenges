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

    scenario 'Signs up and gets automatically joined to the challenge and get redirected there' do
      challenge = create(:challenge, name: "Awesome Challenge")
      visit challenge_path(challenge)
      click_link "Sign me up"
      fill_in 'Name', with: "Eric"
      fill_in 'Email', with: "eric@example.com"
      fill_in 'Password', with: "helloworld"
      fill_in 'Password confirmation', with: "helloworld"
      click_button "Sign up"
      expect(Membership.count).to eq 1
      expect(challenge.members.first.name).to eq "Eric"
      expect(page).to have_content("Awesome Challenge")
      expect(page).to have_content("My Challenges")
    end

    scenario "New User SIGNS UP with facebook from a challenge page" do
      challenge = create(:challenge, name: "Awesome Challenge")
      email = "barry.allen@flash.com"
      mock_auth_hash("facebook", email)
      password = Faker::Internet.password
      visit challenge_path(challenge)
      click_link "Sign me up"
      within('.new_user') do
        click_link "Sign in with Facebook"
      end
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button "Continue"
      expect(page).to have_content("Awesome Challenge")
      expect(page).to have_content("My Challenges")
    end
  end
end
