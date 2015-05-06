require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User creates a challenge' do
    visit root_path
    click_link 'Create a Challenge'
    expect{
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[welcome_message]', with: "Hello, y'all"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-28"
      click_button "Create Challenge"
    }.to change(Challenge, :count).by(1)
  end

  scenario 'User join a challenge successfully' do
    challenge = create(:challenge)
    visit public_challenges_path
    click_link challenge.name
    click_link "Join Challenge"
    expect(challenge.members).to include user
  end

  scenario 'User joins a challenge group successfully' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    group = challenge.groups.create(name: "UC Irvine", user_id: user.id)

    visit(challenge_path(challenge))
    click_link "UC Irvine"

    expect(user.groups).to include group
  end

end
