require 'spec_helper'

feature 'Owner manages group members within challenge' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'Challenge owner adds a group but does not become a member of that group' do
    challenge = create(:challenge, owner_id: user.id, name: "Wonderful")
    membership = create(:membership, :with_statistics, challenge: challenge, user: user)

    visit creator_challenge_path(challenge)
    click_link "Add a group"
    fill_in "Group Name", with: "Awesome"
    click_button "Create Group"
    group = Group.first
    expect(group.user_id).to eq user.id
    expect(group.memberships).not_to include membership
  end

  scenario 'Challenge owner adds a group and another user joins the group and updates stats automatically' do
    user2 = create(:user)
    start_date = Date.today
    challenge = create(:challenge_with_readings, 
                        chapters_to_read: "Matt 1-2",
                        begindate: start_date,
                        owner_id: user.id)
    m1 = create(:membership, :with_statistics, challenge: challenge, user: user)
    m2 = create(:membership, :with_statistics, challenge: challenge, user: user2)

    visit creator_challenge_path(challenge) #owner logs in and creates a group
    click_link "Add a group"
    fill_in "Group Name", with: "Awesome"
    click_button "Create Group"
    group = Group.first
    logout(user)

    login(user2)

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

    #group_stat should be 50 because user2 completed half of challenge
    group_stat = group.group_statistic_progress_percentage

    #user2 joins group
    visit(challenge_path(challenge))
    click_link "Join Group"
    group_stat.reload

    expect(group_stat.value).to eq 50
  end

  scenario "Challenge owner cannot access Change-Group pull-down option for group's owner" do
    user2 = create(:user)
    challenge = create(:challenge, owner_id: user.id, name: "Wonderful")
    membership = create(:membership, challenge: challenge, user: user2)
    group = create(:group, challenge_id: challenge.id, user_id: user2.id)

    visit edit_creator_challenge_membership_path(challenge_id: challenge.id, id: membership.id)
    expect(page).to_not have_content("Select a Group")
  end

  scenario 'Adds a challenge member to a goup within the challenge'
    pending "TODO"

  scenario 'Changes challenge group member to another group within same challenge' 
    pending "TODO"

end


