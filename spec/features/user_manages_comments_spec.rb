require 'spec_helper'

feature 'User manages comments' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User posts a comment' do
    challenge = create(:challenge, :with_readings, owner_id: user.id)
    challenge.groups.create(name: "UCLA", user_id: user.id)
    challenge.join_new_member(user)
    visit member_challenge_path(challenge)
    click_link "Join Group"
    fill_in 'comment_content', with: "Testing"
    click_button "Post"
    expect(page).to have_content("Testing")
  end
end
