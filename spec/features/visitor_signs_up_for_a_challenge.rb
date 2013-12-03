require 'spec_helper'

feature 'Visitor signs up for an existing bible challenge' do
  scenario "with a valid email" do
    # should this be factories?
    #sign_up_and_in
    #create_challenge(name: "Some Challenge", subdomain: "somesubdomain", begindate: "2013-10-30", enddate: "2013-11-30")
    let(:challenge) {FactoryGirl.create(:challenge, subdomain: "woot")}




  end

  pending "with invalid email"
end




