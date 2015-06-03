require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user, :with_profile)}

  before(:each) do
    login(user)
  end

  scenario 'User creates a challenge' do
    visit root_path
    click_link 'Create a Challenge'
    expect{
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-28"
      click_button "Create Challenge"
    }.to change(Challenge, :count).by(1)
  end

  scenario 'User joins a challenge successfully' do
    challenge = create(:challenge)
    visit challenges_path
    click_link challenge.name
    click_link "Join Challenge"
    expect(challenge.members).to include user
  end

  scenario 'User joins own challenge successfully' do
    challenge = create(:challenge, owner_id: user.id)
    visit challenges_path
    click_link challenge.name
    click_link "Join Challenge"
    expect(challenge.members).to include user
  end

  scenario 'User should see the Leave Challenge link instead of the Join link if he already in this challenge' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit challenges_path
    click_link challenge.name

    expect(page).to have_content("Unsubscribe me from this challenge")
  end

  scenario 'User leaves a challenge successfully' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit challenges_path
    click_link challenge.name
    click_link "Unsubscribe me from this challenge"
    expect(challenge.members).not_to include user
  end

  scenario 'User should leave his or her group automatically once the user leaves the challenge' do
    challenge = create(:challenge)
    group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
    create(:membership, challenge: challenge, user: user, group_id: group.id)
    visit challenges_path
    click_link challenge.name
    click_link "Unsubscribe me from this challenge"

    expect(challenge.members).not_to include user
    expect(Membership.count).to eq 0
  end
end
