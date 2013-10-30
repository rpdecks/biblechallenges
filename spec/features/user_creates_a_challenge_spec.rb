require 'spec_helper'

feature 'User creates a bible challenge' do


  scenario 'with valid subdomain, name, and start and end dates' do

    visit '/users/sign_up'
    fill_in 'Email', with: 'fakedude@fakedude.com'
    fill_in 'Password', with: 'woot111'
    fill_in 'Password confirmation', with: 'woot111'
    click_button 'Sign up'

    visit '/creator/challenges/new'
    fill_in 'Name', with: 'Some Challenge Name'
    fill_in 'Subdomain', with: 'somesubdomain'
    #save_and_open_page
    fill_in 'Begindate', with: '2013-10-30'
    fill_in 'Enddate', with: '2013-10-31'
    click_button 'Create Challenge'
  end


end
