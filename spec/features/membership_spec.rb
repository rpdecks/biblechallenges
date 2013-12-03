require 'spec_helper'

describe 'Membership creation', type: :feature do

  context 'when the user is signed in' do
    let(:user){create(:user)}
    let(:challenge){create(:challenge)}

    before do
      login user
      visit root_url(subdomain: challenge.subdomain)
    end

    describe 'user joins a challenge' do
      
      it 'joins the challenge' do
        click_button "Join the Challenge"
        page.should have_content 'Thank you for joining!'
      end
      
    end
  end

  context "when the user hasn't signed in" do
    let(:email){'super_new_email@test.com'}
    let(:challenge){create(:challenge)}

    before do
      visit root_url(subdomain: challenge.subdomain)
    end

    describe 'user joins a challenge using only the email' do
      
      it 'joins the challenge' do
        fill_in "membership_form_email", with: email
        click_button "Join the Challenge"        
        page.should have_content 'Thank you for joining, check your email inbox!'
      end

    end

  end


end