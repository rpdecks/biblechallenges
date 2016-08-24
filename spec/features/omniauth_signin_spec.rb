require "spec_helper"

feature "Omniauth Sign In / Sign Up" do

  context "successfully" do
    scenario "Existing facebook user signs in with facebook" do
      user = create(:existing_facebook_user)
      email = user.email
      mock_auth_hash("google_oauth2", email)
      visit root_path
      click_link "Log in"
      click_link "Log in with Google"
      expect(current_path).to eq root_path
      expect(page).to have_content("Successfully authenticated from google_oauth2 account.")
      expect(User.count).to eq 1
    end

    scenario "New User SIGNS UP with devise then signs in with google" do
      name = Faker::Name.name
      email = "barry.allen@flash.com"
      password = Faker::Internet.password

      visit root_path
      click_link "Log in"
      click_link "Sign up"
      fill_in 'user[name]', with: name
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button "Sign up"
      expect(page).to have_content("You have signed up successfully")
      click_link "Log out"

      mock_auth_hash("google_oauth2", email)
      click_link "Log in"
      click_link "Log in with Google"
      expect(page).to have_content("Successfully authenticated")
    end
  end
end
