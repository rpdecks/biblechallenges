require 'spec_helper'

feature 'User invites friends via email' do
  let(:user) {create(:user)}
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    login(user)
  end

  scenario 'User invites a friend who is not signed up with Bible Challenge' do
    challenge = create(:challenge, :with_readings, owner_id: user.id)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    expect{
      fill_in 'invite_email', with: 'fakedude@example.com'
      click_button "Add"
    }.to change(User, :count).by(1)
    expect(Membership.count).to eq 2
  end
end


