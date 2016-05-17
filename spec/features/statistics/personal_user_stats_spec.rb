require "spec_helper"

feature "calculates personal user stats" do
  let(:user) {create(:user)}

  context "multiple chapters logged per day" do
    scenario "calculate current streaks correctly" do
      challenge = create(:challenge_with_readings,
                         owner: user)
      m = create(:membership, user: user, challenge: challenge)
      user.associate_statistics
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 1 with two readings
      Timecop.travel(1.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 2 with two readings
      Timecop.travel(1.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 3 with two readings

      user.update_stats
      user.reload
      expect(user.user_statistic_days_read_in_a_row_current.value).to eq 3

      Timecop.return
    end

    scenario "calculate all-time streaks correctly" do
      challenge = create(:challenge_with_readings,
                         owner: user)
      m = create(:membership, user: user, challenge: challenge)
      user.associate_statistics
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 1 with two readings
      Timecop.travel(1.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 2 with two readings
      Timecop.travel(2.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 4 with two readings
      Timecop.travel(1.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 5 with two readings
      Timecop.travel(1.day)
      create_list(:membership_reading, 2, membership: m, user_id: user.id) # day 6 with two readings

      user.update_stats
      user.reload
      expect(user.user_statistic_days_read_in_a_row_all_time.value).to eq 3

      Timecop.return
    end
  end

  context "Joins a challenge, logs some readings, and leaves the challenge" do
    scenario "personal statistics are removed" do
      challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-3",
                         owner: user, begindate: Date.today)
      user2 = create(:user, email: "guy@example.com")
      login(user2)
      challenge.join_new_member([user, user2])
      Membership.where(user_id: user2.id).first

      visit member_challenge_path(challenge)
      click_link "Matthew 1"
      click_link_or_button "Log Matthew 1"

      visit challenge_path(challenge)
      click_link "Unsubscribe"

      user2.update_stats
      expect(user2.user_statistic_chapters_read_all_time.value).to eq 0
      expect(user2.user_statistic_days_read_in_a_row_current.value).to eq 0
      expect(user2.user_statistic_days_read_in_a_row_all_time.value).to eq 0
    end
  end
end
