require 'spec_helper'

feature "User logs reading" do

  let(:user) {create(:user)}

  before(:each) {
    login(user)
  }

  scenario "via challenge page 'Log' button" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    create(:membership, user: user, challenge: challenge)

    visit member_challenge_path(challenge)
    expect{
      click_link_or_button "Log Matthew 1"
    }.to change(user.membership_readings, :count).by(1)
  end

  scenario "correctly calculate statistics using user's timezone" do
    skip "look at controller tests first"
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-2")
    ChallengeCompletion.new(challenge)
    membership = create(:membership, user: user, challenge: challenge)
    MembershipStatisticAttacher.attach_statistics(membership)

    visit member_challenge_path(challenge)
    click_link_or_button "Log Matthew 1"
    #UpdateStatsWorker.drain

    Timecop.travel(1.day)
    visit member_challenge_path(challenge)
    click_link_or_button "Log Matthew 2"

    expect(user.user_statistic_chapters_read_all_time.value).to eq 2
    expect(user.user_statistic_days_read_in_a_row_all_time.value).to eq 2
    expect(user.user_statistic_days_read_in_a_row_current.value).to eq 2

    Timecop.return
  end

  scenario "via challenge page readings table checkbox"
end


