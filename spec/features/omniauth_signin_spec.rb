require "spec_helper"

feature "Omniauth Sign In / Sign Up" do
  scenario "New User SIGNS UP with facebook, logs out, logs back in" do
    mock_auth_hash
    password = Faker::Internet.password
    visit root_path
    click_link "Sign in with Facebook"
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    click_button "Continue"
    expect(page).to have_content("Succesfully signed up with facebook")

    click_link "Logout"

    click_link "Login"
    fill_in 'user[email]', with: "barry.allen@flash.com"
    fill_in 'user[password]', with: password
    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end

  scenario "New User SIGNS UP with google, logs out, logs back in" do
    mock_auth_hash
    password = Faker::Internet.password
    visit root_path
    click_link "Sign in with Google"
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password
    click_button "Continue"
    expect(page).to have_content("Succesfully signed up with google")

    click_link "Logout"

    click_link "Login"
    fill_in 'user[email]', with: "barry.allen@flash.com"
    fill_in 'user[password]', with: password
    click_button "Sign in"

    expect(page).to have_content("Signed in successfully")
  end
end
