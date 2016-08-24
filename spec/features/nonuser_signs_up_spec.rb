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
    expect(User.last.email).to eq "eric@example.com"
    expect(page).to have_content("Awesome Challenge")
  end
end
