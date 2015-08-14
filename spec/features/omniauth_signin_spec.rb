require "spec_helper"

feature "Omniauth Sign In / Sign Up" do

  scenario "Existing user signs in with facebook" do
    user = create(:existing_facebook_user)
    mock_auth_user("facebook", user)
    visit root_path
    # expect not to raise Capybara::InfiniteRedirectError
    click_link "Sign in with Facebook"
    expect(current_path).to eq "/"
  end

  scenario "New User SIGNS UP with facebook, logs out, logs back in" do
    email = "barry.allen@flash.com"
    mock_auth_hash("facebook", email)
    password = Faker::Internet.password
    visit root_path
    click_link "Sign in with Facebook"
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    click_button "Continue"
    expect(page).to have_content("You have signed up successfully")

    click_link "Logout"

    click_link "Login"
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end

  scenario "New User SIGNS UP with google, logs out, logs back in" do
    pending "removed google sign up temporarily"
    email = "peter.parker@spider.man"
    mock_auth_hash("google_oauth2", email)
    password = Faker::Internet.password
    visit root_path
    click_link "Sign in with Google"
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    click_button "Continue"
    expect(page).to have_content("You have signed up successfully")

    click_link "Logout"

    click_link "Login"
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end

  scenario "Reject if password is different from password confirmation" do
    mock_auth_hash("facebook", "barry.allen@flash.com")
    password = Faker::Internet.password
    visit root_path
    click_link "Sign in with Facebook"
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password+"2"
    click_button "Continue"
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
