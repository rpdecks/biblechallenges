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

  scenario "log reading via email correctly"

  scenario "via challenge page readings table checkbox"
end


