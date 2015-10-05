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

  scenario "Calculate membership on schedule percentage" do
    user.time_zone = "Pacific Time (US & Canada)"

    # create challenge
    challenge_date = Date.new(2015, 7, 4)
    challenge = create(:challenge_with_readings,
                       chapters_to_read: "Matthew 1-3",
                       owner: user, begindate: challenge_date)
    membership = create(:membership, user: user, challenge: challenge)
    membership.associate_statistics

    Sidekiq::Testing.inline! do
      Time.zone = user.time_zone
      first_day_read_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # for user at PST
      Timecop.travel(first_day_read_time)

      Time.zone = "UTC" # heroku timezone
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 1"

      Timecop.travel(1.day)
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 2"

      expect(membership.membership_statistics.find_by_type(
        "MembershipStatisticOnSchedulePercentage").value).to eq 100

      Timecop.return
    end
  end

  scenario "Calculate days read in a row current streak" do
    user.time_zone = "Pacific Time (US & Canada)"

    # create challenge
    challenge_date = Date.new(2015, 7, 4)
    challenge = create(:challenge_with_readings,
                       chapters_to_read: "Matthew 1-3",
                       owner: user, begindate: challenge_date)
    create(:membership, user: user, challenge: challenge)
    user.associate_statistics

    Sidekiq::Testing.inline! do
      Time.zone = "UTC" # heroku timezone

      # read in morning on first day
      Timecop.travel(Time.zone.local(2015, 7, 4, 15, 0, 0))
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 1"

      # read at night on second day
      Timecop.travel(Time.zone.local(2015, 7, 6, 2, 0, 0))
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 2"

      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 2
      Timecop.return
    end
  end
end
