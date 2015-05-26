require 'spec_helper'

feature 'User manages groups' do
  let(:user) {create(:user, :with_profile)}

  before(:each) do
    login(user)
  end

  context "Not having joined the challenge" do
    scenario "When joins a group, also joins the challenge" do
      challenge = create(:challenge)
      group = challenge.groups.create(name: "UCLA", user_id: user.id)

      visit member_group_path(group)
      click_link "Join Group"

      expect(user.challenges).to include challenge
      expect(user.groups).to include group
    end
    scenario "Doesn't see 'create a group' option" do
      challenge = create(:challenge)

      visit challenge_path(challenge)

      expect(page).not_to have_link "Create a group"
    end
  end

  context "Having joined the challenge" do
    scenario 'User creates a group and is automatically a member of the group' do
      challenge = create(:challenge)
      membership = create(:membership, challenge: challenge, user: user)

      visit challenge_path(challenge)
      click_link 'Create a group'
      fill_in 'Group Name', with: "Test group"
      click_button 'Create Group'

      expect(page).to have_content("Test group")
      expect(Group.count).to eq 1
      group = Group.first
      expect(group.challenge).to eq challenge
      expect(group.user).to eq user
      expect(membership.reload.group).to eq group
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
  end

  context "Already in a group" do
    scenario 'Owner of a group can delete the group and will unsubscribe all members in the group' do
      user1 = create(:user, :with_profile)
      user2 = create(:user, :with_profile)
      challenge = create(:challenge)
      group = challenge.groups.create(user_id: user.id)
      membership = create(:membership, challenge: challenge, group: group, user: user1)
      membership2 = create(:membership, challenge: challenge, group: group, user: user2)
      visit member_group_path(group)

      click_link 'Delete Group'

      expect(Group.count).to eq 0
      expect(membership.reload.group).to eq nil
      expect(membership2.reload.group).to eq nil
    end

    scenario 'User should not see the Create Group link' do
      #setup
      challenge = create(:challenge)
      group1 = challenge.groups.create(name: "UCLA", user_id: user.id)
      create(:membership, challenge: challenge, user: user, group_id: group1.id)
      visit(challenge_path(challenge))
      expect(page).not_to have_link("Create a group")
    end

    scenario 'User should see the Leave Group link instead of the Join link' do
      #setup
      challenge = create(:challenge)
      group1 = challenge.groups.create(name: "UCLA", user_id: user.id)
      create(:membership, challenge: challenge, user: user, group_id: group1.id)
      visit(challenge_path(challenge))
      click_link group1.name
      expect(page).not_to have_content("Join Group")
      expect(page).to have_content("Leave Group")
    end

    scenario 'User should be able to leaves a group successfully' do
      challenge = create(:challenge)
      group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
      create(:membership, challenge: challenge, user: user, group_id: group.id)

      visit(challenge_path(challenge))
      click_link "UC Irvine"
      click_link "Leave Group"

      expect(user.groups).not_to include group
    end
  end
end
