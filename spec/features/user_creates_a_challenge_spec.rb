require 'spec_helper'

feature 'User creates a valid bible challenge', :type => :feature do
  #I'd prefer to use describe / it how can I do that?  :type => :feature  ?

  scenario 'with valid subdomain, name, and start and end dates' do
    sign_up_and_in
    create_challenge(name: "Some Challenge", subdomain: "somesubdomain", begindate: "2013-10-30", enddate: "2013-11-30")
    #expect(page).to have_content 'Successfully created Challenge'  why does this not work? pdb
    page.should have_content 'Successfully created Challenge'
  end

  https://github.com/asymmetric/dotfiles.castle/tree/master/home



  pending "with invalid dates"
  pending "with invalid subdomain"
  pending "with invalid name"



end
