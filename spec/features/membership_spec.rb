require 'spec_helper'

describe 'Membership creation', type: :feature do

  context 'when the user is signed in' do

    describe 'user joins a challenge' do
      
      it 'joins the challenge' do
        user = create(:user)
        challenge = create(:challenge)
        challenge.active = true
        challenge.save

        login user
        visit root_url(subdomain: challenge.subdomain)
        click_button "Join the Challenge"
        page.should have_content 'Thank you for joining!'
      end
      
    end
  end

  context "when the user hasn't signed in" do

    describe 'user joins a challenge using only the email' do
      
      it 'joins the challenge' do
        email = 'super_new_email@test.com'
        challenge = create(:challenge)
        challenge.active = true
        challenge.save


        visit root_url(subdomain: challenge.subdomain)

        fill_in "membership_form_email", with: email
        click_button "Join the Challenge"        
        page.should have_content 'Thank you for joining. check your email inbox for more details!'
      end

    end

  end


end
