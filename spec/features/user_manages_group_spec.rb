require 'spec_helper'

feature 'User manages groups' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User creates a group' do
    challenge = create(:challenge)
    visit(challenge_path(challenge))
    click_link 'Create a group'
    fill_in 'Group Name', with: "Test group"
    click_button 'Create Group'


    expect(page).to have_content("Test group")
    expect(Group.count).to eq 1
    group = Group.first
    expect(group.challenge_id).to eq challenge.id
    expect(group.user_id).to eq user.id
  end

  scenario 'User joins a group successfully' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    group = challenge.groups.create(name: "UC Irvine", user_id: user.id)

    visit(challenge_path(challenge))
    click_link "UC Irvine"
    click_link "Join Group"

    expect(user.groups).to include group
  end

  scenario 'User should see the Leave Group link instead of the Join link if he is already in a group in this challenge' do
    #setup
    challenge = create(:challenge)
    group1 = challenge.groups.create(name: "UCLA", user_id: user.id)
    create(:membership, challenge: challenge, user: user, group_id: group1.id)
    visit(challenge_path(challenge))
    click_link group1.name
    expect(page).not_to have_content("Join Group")
    expect(page).to have_content("Leave Group")
  end

  scenario 'User leaves a group successfully' do
    challenge = create(:challenge)
    group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
    create(:membership, challenge: challenge, user: user, group_id: group.id)

    visit(challenge_path(challenge))
    click_link "UC Irvine"
    click_link "Leave Group"

    expect(user.groups).not_to include group
  end
end
