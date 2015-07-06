require 'spec_helper'

feature 'User manages challenges' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'User creates a challenge' do
    visit root_path
    click_link 'Create a challenge'
    expect{
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-28"
      click_button "Create Challenge"
    }.to change(Challenge, :count).by(1)
    number_of_stats = ChallengeStatistic.descendants.size
    expect(ChallengeStatistic.count).to eq number_of_stats
  end

  scenario 'User creates a challenge and automatically joins the challenge' do
    visit root_path
    click_link 'Create a challenge'
    expect{
      fill_in 'challenge[name]', with: "challenge 1"
      fill_in 'challenge[begindate]', with: Date.today
      fill_in 'challenge[chapters_to_read]', with: "Matthew 1-28"
      click_button "Create Challenge"
    }.to change(Challenge, :count).by(1)
    expect(Membership.count).to be 1
    expect(Membership.first.user).to eq user
  end

  scenario 'User joins a challenge successfully' do
    challenge = create(:challenge, :with_readings)
    ChallengeCompletion.new(challenge)
    visit challenge_path(challenge)
    click_link "Join Challenge"
    expect(challenge.members).to include user
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
