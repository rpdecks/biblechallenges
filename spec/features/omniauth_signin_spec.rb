require "spec_helper"

feature "Omniauth Sign In / Sign Up" do

  context "successfully" do
    scenario "Existing facebook user signs in with facebook" do
      user = create(:existing_facebook_user)
      mock_auth_user("facebook", user)
      visit root_path
      click_link "Sign in with Facebook"
      expect(current_path).to eq root_path
      expect(page).to have_content("Successfully authenticated from facebook account.")
      expect(User.count).to eq 1
    end

    scenario "New User SIGNS UP with devise then signs in with facebook" do
      name = Faker::Name.name
      email = "barry.allen@flash.com"
      password = Faker::Internet.password

      visit root_path
      click_link "Login"
      click_link "Sign up"
      fill_in 'user[name]', with: name
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button "Sign up"
      expect(page).to have_content("You have signed up successfully")
      click_link "Logout"

      mock_auth_hash("facebook", email)
      click_link "Sign in with Facebook"
      expect(page).to have_content("Successfully authenticated")
    end

    scenario "New User SIGNS UP with devise then signs in with google" do
      name = Faker::Name.name
      email = "barry.allen@flash.com"
      password = Faker::Internet.password

      visit root_path
      click_link "Login"
      click_link "Sign up"
      fill_in 'user[name]', with: name
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_button "Sign up"
      expect(page).to have_content("You have signed up successfully")
      click_link "Logout"

      mock_auth_hash("google_oauth2", email)
      click_link "Sign in with Google"
      expect(page).to have_content("Successfully authenticated")
    end
  end

  context "Unsuccessfully" do
    scenario "New User SIGNS UP with google, logs out, logs back in via devise" do
      email = "peter.parker@spider.man"
      mock_auth_hash("google_oauth2", email)
      password = Faker::Internet.password
      visit root_path
      click_link "Sign in with Google"
      click_link "Logout"

      click_link "Login"
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button "Sign in"

      expect(page).to have_content("That account appears to be a Google Account without a password. Try using the Log in with Google button.")
    end

    scenario "New User SIGNS UP with facebook, logs out, logs back in through devise" do
      email = "barry.allen@flash.com"
      mock_auth_hash("facebook", email)
      password = Faker::Internet.password
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Logout"

      click_link "Login"
      fill_in 'user[email]', with: email
      fill_in 'user[password]', with: password
      click_button "Sign in"

      expect(page).to have_content("That account appears to be a Facebook Account without a password. Try using the Log in with Facebook button.")
    end

    scenario "New User SIGNS UP with google, logs out, logs back in with facebook with the same email" do
      email = "peter.parker@spider.man"
      mock_auth_hash("google_oauth2", email)
      mock_auth_hash("facebook", email)
      visit root_path
      click_link "Sign in with Google"
      expect(page).to have_content("Successfully authenticated")
      click_link "Logout"

      click_link "Sign in with Facebook"

      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content("It looks like you already have a Google account with the same email. Try using the Log in with Google button.")
    end

    scenario "New User SIGNS UP with facebook, logs out, logs back in with google with the same email" do
      email = "peter.parker@spider.man"
      mock_auth_hash("facebook", email)
      mock_auth_hash("google_oauth2", email)
      visit root_path
      click_link "Sign in with Facebook"
      click_link "Logout"

      click_link "Sign in with Google"

      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content("It looks like you already have a Facebook account with the same email. Try using the Log in with Facebook button.")
    end
  end
end
