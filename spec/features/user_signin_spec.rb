require "spec_helper"

feature "User Signs In" do
  let(:user) {create(:user)}

  scenario "User signs in via website and sees only the challenges related to him" do
    challenge = create(:challenge, owner_id: user.id, name: "Awesome")
    create(:membership, challenge: challenge, user:user)
    challenge2 = create(:challenge, name: "Not Cool")

    visit root_path
    click_link "Login"
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: "password"
    click_button "Sign in"

    expect(page).to have_content(challenge.name)
    expect(page).to_not have_content(challenge2.name)
  end

  scenario "User signs in via website with no challenges shoudld see home page" do
    challenge = create(:challenge, name: "Awesome")
    challenge2 = create(:challenge, name: "Not Cool")

    visit root_path
    click_link "Login"
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: "password"
    click_button "Sign in"

    expect(page).to have_content(challenge.name)
    expect(page).to have_content(challenge2.name)
  end
end
