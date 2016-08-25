require "spec_helper"

describe "Password resets" do
  it "emails user when requesting password reset" do
    email = "peter.parker@spider.man"
    mock_auth_hash("google_oauth2", email)
    visit root_path
    click_link "Log in"
    click_link "Log in with Google"
    click_link "Log out"

    click_link "Log in"
    click_link "Forgot your password?"
    fill_in "Email", with: email
    click_button "Send me reset password instructions"
    expect(page).to have_content("You will receive an email with instructions")
    expect(last_email.to).to eq [email]
  end

  it "updates the user password when confirmation matches" do
    email = "peter.parker@spider.man"
    new_password = "awesomeness"
    mock_auth_hash("google_oauth2", email)
    visit root_path
    click_link "Log in"
    click_link "Log in with Google"
    click_link "Log out"
    user = User.where(email: email).first

    click_link "Log in"
    click_link "Forgot your password?"
    fill_in "Email", with: email
    click_button "Send me reset password instructions"

    link = links_in_email(last_email).first
    visit link

    fill_in "New password", :with => new_password
    fill_in "Confirm new password", :with => new_password
    click_button "Change my password"
    user.reload

    visit root_path
    click_link "Log in"
    fill_in "Email", with: email
    fill_in "Password", with: new_password
    click_button "Log in"
    expect(page).to have_content("Signed in successfully")
  end
end

