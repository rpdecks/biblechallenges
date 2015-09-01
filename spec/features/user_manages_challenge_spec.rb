require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User joins a challenge successfully and receives welcome email' do
    Sidekiq::Testing.inline! do
      challenge = create(:challenge, :with_membership, :with_readings)
      visit challenge_path(challenge)
      click_link "Join Challenge"
      expect(challenge.members).to include user
      expect(ActionMailer::Base.deliveries.size).to eq 2 #Thanks for joining and today's reading.
      successful_creation_email = ActionMailer::Base.deliveries.first
      expect(successful_creation_email.subject).to have_content("Thanks for joining")
    end
  end

  scenario 'User joins a challenge and the challenge stats get updated automatically' do
    start_date = Date.today
    challenge = create(:challenge_with_readings, 
                       :with_membership,
                         chapters_to_read: "Matt 1-2", begindate: start_date, owner_id: user.id)
    MembershipCompletion.new(challenge.memberships.first)
    ChallengeCompletion.new(challenge)
    user2 = create(:user)
    login(user2)
    m1 = challenge.memberships.first

    r = challenge.readings.first
    create(:membership_reading, membership: m1, reading: r)
    m1.update_stats
    challenge.update_stats
    challenge_stat = challenge.challenge_statistic_progress_percentage

    visit challenge_path(challenge)
    click_link "Join Challenge"
    challenge_stat.reload

    expect(challenge_stat.value).to eq 25
  end

  scenario 'User should see the Leave Challenge link instead of the Join link if he already in this challenge' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit challenge_path(challenge)

    expect(page).to have_content("Unsubscribe")
  end

  scenario 'User leaves a challenge successfully' do
    challenge = create(:challenge)
    create(:membership, challenge: challenge, user: user)
    visit challenge_path(challenge)
    click_link "Unsubscribe"
    expect(challenge.members).not_to include user
  end

  scenario 'User leaves a challenge and the challenge stats get updated automatically' do
    start_date = Date.today
    challenge = create(:challenge_with_readings,
                       :with_membership,
                         chapters_to_read: "Matt 1-2", begindate: start_date, owner_id: user.id)
    MembershipCompletion.new(challenge.memberships.first)
    ChallengeCompletion.new(challenge)
    user2 = create(:user)
    login(user2)
    m1 = challenge.memberships.first
    m2 = create(:membership, challenge: challenge, user: user2)

    r = challenge.readings.first
    create(:membership_reading, membership: m1, reading: r)
    m1.update_stats
    m2.update_stats
    challenge.update_stats
    challenge_stat = challenge.challenge_statistic_progress_percentage

    visit challenge_path(challenge)
    click_link "Unsubscribe"
    challenge_stat.reload

    expect(challenge_stat.value).to eq 50
  end

  scenario 'User should leave his or her group automatically once the user leaves the challenge' do
    challenge = create(:challenge)
    group = challenge.groups.create(name: "UC Irvine", user_id: user.id)
    membership = create(:membership, challenge: challenge, user: user, group_id: group.id)
    visit challenge_path(challenge)
    click_link "Unsubscribe"

    expect(challenge.members).not_to include user
    expect{Membership.find(membership.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
