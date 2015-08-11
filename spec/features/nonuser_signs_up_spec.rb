require 'spec_helper'

feature 'Nonuser signs up from challenge show page and get redirected there' do
  scenario 'Wtih Devise' do
    challenge = create(:challenge, name: "Awesome Challenge")
    visit challenge_path(challenge)
    click_link "Sign me up"
    fill_in 'Name', with: "Eric"
    fill_in 'Email', with: "eric@example.com"
    fill_in 'Password', with: "helloworld"
    fill_in 'Password confirmation', with: "helloworld"
    click_button "Sign up"
    membership = Membership.first
    expect(membership.membership_statistics).not_to be_empty
    expect(challenge.members.first.name).to eq "Eric"
    expect(page).to have_content("Awesome Challenge")
  end

  scenario "With facebook" do
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
    membership = Membership.first
    expect(membership.membership_statistics).not_to be_empty
    expect(page).to have_content("Awesome Challenge")
    expect(page).to have_content("My Challenges")
  end
end
