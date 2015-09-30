require "spec_helper"

feature "calculates personal stats" do
  let(:user) {create(:user)}

  before(:each) {
    login(user)
  }

  scenario "challenge in eastern time. user in paris" do
    user.time_zone = "Paris"

    # create challenge
    Time.zone = "Eastern Time (US & Canada)"
    challenge_creation_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # time challenge was created
    Timecop.travel(challenge_creation_time)
    challenge = create(:challenge_with_readings,
                       chapters_to_read: "Matthew 1-3",
                       owner: user)
    binding.pry
    create(:membership, user: user, challenge: challenge)
    user.associate_statistics

    Sidekiq::Testing.inline! do
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 1"
      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 1

      #Timecop.travel(1.day)
      #visit member_challenge_path(challenge)
      #click_link_or_button "Log Matthew 2"
      #user.reload
      #expect(user.user_statistic_days_read_in_a_row_current.value).to eq 2

      #Timecop.travel(1.day)
      #visit member_challenge_path(challenge)
      #click_link_or_button "Log Matthew 3"
      #user.reload
      #expect(user.user_statistic_days_read_in_a_row_current.value).to eq 3
    end

    Timecop.return
  end

  scenario "challenge in eastern time. user in paris" do
    user.time_zone = "Paris"

    # create challenge
    Time.zone = "Eastern Time (US & Canada)"
    challenge_creation_time = Time.zone.local(2015, 7, 4, 23, 0, 0) # time challenge was created
    Timecop.travel(challenge_creation_time)
    challenge = create(:challenge_with_readings,
                       chapters_to_read: "Matthew 1-3",
                       owner: user)
    binding.pry
    create(:membership, user: user, challenge: challenge)
    user.associate_statistics

    Sidekiq::Testing.inline! do
      visit member_challenge_path(challenge)
      click_link_or_button "Log Matthew 1"
      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 1

      #Timecop.travel(1.day)
      #visit member_challenge_path(challenge)
      #click_link_or_button "Log Matthew 2"
      #user.reload
      #expect(user.user_statistic_days_read_in_a_row_current.value).to eq 2

      #Timecop.travel(1.day)
      #visit member_challenge_path(challenge)
      #click_link_or_button "Log Matthew 3"
      #user.reload
      #expect(user.user_statistic_days_read_in_a_row_current.value).to eq 3
    end

    Timecop.return
  end
end
