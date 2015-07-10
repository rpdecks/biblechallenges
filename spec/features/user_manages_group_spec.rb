require 'spec_helper'

feature 'User manages groups' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  context "Not having joined the challenge" do
    scenario "When joins a group, also joins the challenge" do
      challenge = create(:challenge)
      group = challenge.groups.create(name: "UCLA", user_id: user.id)

      visit member_challenge_path(challenge)
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
      click_link "Join Group"

      expect(user.groups).to include group
    end
    scenario 'User joins a group and group stats update automatically' do
      user2 = create(:user)
      start_date = Date.today
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: "Matt 1-2", begindate: start_date, owner_id: user.id)
      m2 = create(:membership, challenge: challenge, user: user2)
      group = challenge.groups.create(name: "UC Irvine", user_id: user2.id)
      group.add_user_to_group(challenge, user2)

      #associate statistic
      m2.membership_statistics << MembershipStatisticProgressPercentage.create
      group.group_statistics << GroupStatisticProgressPercentage.create

      #generate 1 membership_reading for user2
      r = challenge.readings.first
      create(:membership_reading, membership: m2, reading: r)

      #update stats
      m2.update_stats

      #group_stat should be 50 because user2 completed half of challenge
      group_stat = group.group_statistic_progress_percentage

      #user joins group
      visit(challenge_path(challenge))
      click_link "Join Group"
      group_stat.reload

      expect(group_stat.value.to_i).to eq 25
    end
    scenario 'User leaves a group and group stats update automatically' do
      user2 = create(:user)
      start_date = Date.today
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: "Matt 1-2", begindate: start_date, owner_id: user.id)
      m1 = challenge.memberships[0]
      m2 = create(:membership, challenge: challenge, user: user2)
      group = challenge.groups.create(name: "UC Irvine", user_id: user2.id)

      #adding both users to group
      group.add_user_to_group(challenge, user2)
      group.add_user_to_group(challenge, user)

      #associate statistic
      m1.membership_statistics << MembershipStatisticProgressPercentage.create
      m2.membership_statistics << MembershipStatisticProgressPercentage.create
      group.group_statistics << GroupStatisticProgressPercentage.create

      #generate 1 membership_reading for user2
      r = challenge.readings.first
      create(:membership_reading, membership: m2, reading: r)

      #update stats
      m1.update_stats
      m2.update_stats
      group.update_stats

      #group_stat should be 25 because only 1/4 recorded reading
      group_stat = group.group_statistic_progress_percentage

      #user leaving group
      visit(challenge_path(challenge))
      click_link "Leave Group"
      group_stat.reload

      #Group_stat should be 50 because 1 user left group
      expect(group_stat.value.to_i).to eq 50
    end
    scenario 'User sees members of a group without being in the group' do
      challenge = create(:challenge)
      user2 = create(:user)
      create(:membership, challenge: challenge, user: user)
      create(:membership, challenge: challenge, user: user2)
      group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
      group.add_user_to_group(challenge, user)
      visit(challenge_path(challenge))
      login(user2)
      visit(challenge_path(challenge))

      click_link "Join Group"

      expect(user2.groups).to include group
    end
  end

  context "Already in a group" do
    scenario 'Owner of a group can delete the group and will unsubscribe all members in the group' do
      user1 = create(:user)
      user2 = create(:user)
      challenge = create(:challenge)
      group = challenge.groups.create(user_id: user.id)
      create(:membership, challenge: challenge, group: group, user: user)
      membership = create(:membership, challenge: challenge, group: group, user: user1)
      membership2 = create(:membership, challenge: challenge, group: group, user: user2)
      visit member_challenge_path(challenge)

      click_link 'Delete Group'

      expect(Group.count).to eq 0
      expect(membership.reload.group).to eq nil
      expect(membership2.reload.group).to eq nil
    end

    scenario 'Owner of a group can only see delete the group option' do
      challenge = create(:challenge)
      group = challenge.groups.create(user_id: user.id, name: "Awesome")
      create(:membership, challenge: challenge, group: group, user: user)
      visit member_challenge_path(challenge)
      expect(page).not_to have_content("Leave Group")
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
      non_owner = create(:user)
      challenge = create(:challenge)
      group1 = challenge.groups.create(name: "UCLA", user_id: non_owner.id)
      create(:membership, challenge: challenge, user: user, group_id: group1.id)
      visit(challenge_path(challenge))
      expect(page).not_to have_content("Join Group")
      expect(page).to have_content("Leave Group")
    end

    scenario 'User should be able to leaves a group successfully' do
      non_owner = create(:user)
      challenge = create(:challenge)
      group = challenge.groups.create(name: "UC Irvine", user_id: non_owner.id)
      create(:membership, challenge: challenge, user: user, group_id: group.id)

      visit(challenge_path(challenge))
      click_link "Leave Group"

      expect(user.groups).not_to include group
    end
  end
end
