require 'spec_helper'

feature 'User creates a valid bible challenge' do

  scenario 'with valid subdomain, name, and start and end dates' do

    visit '/users/sign_up'
    fill_in 'Email', with: 'fakedude@fakedude.com'
    fill_in 'Password', with: 'woot111'
    fill_in 'Password confirmation', with: 'woot111'
    click_button 'Sign up'
    #sign_up_as 'fakeguy@fakeland.com', 'woot111'  why won't this work?  ask jose pdb
    visit '/creator/challenges/new'
    fill_in 'Name', with: 'Some Challenge Name'
    fill_in 'Subdomain', with: 'somesubdomain'
    fill_in 'Begindate', with: '2013-10-30'
    fill_in 'Enddate', with: '2013-10-31'
    click_button 'Create Challenge'
    #expect(page).to have_content 'Successfully created Challenge'  why does this not work? pdb
    page.should have_content 'Successfully created Challenge'
  end

  pending "with invalid dates"
  pending "with invalid subdomain"
  pending "with invalid name"



end
