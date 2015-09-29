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

  scenario "correctly calculate user statistics using user's timezone" do
    user.time_zone = "Paris"

    # create a challenge
    Time.zone = "Eastern Time (US & Canada)"
    creation_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # time challenge was created
    Timecop.travel(creation_time)
    challenge = create(:challenge_with_readings,
                       chapters_to_read: "Matthew 1-3",
                       owner: user,
                       begindate: Time.zone.now+1.day)
    ChallengeCompletion.new(challenge)
    create(:membership, user: user, challenge: challenge)
    user.associate_statistics

    # log readings
    Sidekiq::Testing.inline! do
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 2"

      expect(user.user_statistic_days_read_in_a_row_all_time.value).to eq 1
      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 1

      second_day_read_time = Time.local(2015, 7, 5, 23, 0, 0) # a day later, at night
      Timecop.travel(second_day_read_time)
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 3"

      user.reload
      expect(user.user_statistic_days_read_in_a_row_all_time.value).to eq 2
      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 2
    end

    Timecop.return
  end

  scenario "Same challenge, 2 users in different Time zones reads through checking stats" do
    user.time_zone = "Hawaii"
    user2 = create(:user)
    user2.time_zone = "Greenland"

    # create a challenge
    Time.zone = user.time_zone
    creation_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # time challenge was created
    Timecop.travel(creation_time)
    c = create(:challenge, chapters_to_read: "Mat 1-2", begindate: "2015-07-04")
    c.generate_readings
    c.associate_statistics

    visit challenge_path(c)
    click_link "Join Challenge"

    Sidekiq::Testing.inline! do
      click_link "Log Matthew 1" # Expect 1st membership_reading to be logged on July 4 at 11pm in Hawaii
    end
    click_link "Logout"

    Time.zone = user2.time_zone
    reading_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # User2's reads at 11pm in Mexico City
    Timecop.travel(reading_time)

    login(user2)
    visit challenge_path(c)
    click_link "Join Challenge"

    Sidekiq::Testing.inline! do
      click_link "Log Matthew 1" # Expect 2nd membership_reading to be logged on July 4 at 11pm in MX
    end

    #challenge
    binding.pry
    expect(c.challenge_statistics.find_by_type("ChallengeStatisticOnSchedulePercentage").value).to eq 100
    #expect(c.membership_statistics.membership_statistic_chapters_read.reload.value).to eq 2
    #expect(c.membership_statistics.membership_statistic_progress_percentage.reload.value).to eq 50
  end

  scenario "log reading via email correctly"

  scenario "via challenge page readings table checkbox"
end


