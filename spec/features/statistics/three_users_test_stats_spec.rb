require 'spec_helper'

feature 'One user reads various parts of a challenge' do

  # this is a pure test that only uses browser actions...

  context "One user reads various amounts of chapters in the challenge" do
    scenario "Creates a challenge and reads through it, checking stats all the way " do

      create_account_and_log_in(email: 'c@c.com', name: 'C')
      create_a_challenge(name: "One Day", chapters_to_read: "Mat 1-2")  #below

      # the challenge stats should exist, and be zeroed
      c = Challenge.first
      u = User.first
      m = c.membership_for(u)
      expect(c.challenge_statistic_on_schedule_percentage.value).to eq 0
      expect(c.challenge_statistic_chapters_read.value).to eq 0
      expect(c.challenge_statistic_progress_percentage.value).to eq 0

      reading_one, reading_two = c.readings

      #  This is a terrible thing.  I can't simulate clicking on the checkboxes,
      #  I think because they are react components.  So simulating the post action
      #  is as close as I can get to being a "real" user action
      #  This is clicking one box
      click_to_read_a_reading(reading: reading_one, membership: m)
      UpdateStatsWorker.drain

      #individual
      expect(u.user_statistic_chapters_read_all_time.value).to eq 1
      expect(u.user_statistic_days_read_in_a_row_all_time.value).to eq 1
      expect(u.user_statistic_days_read_in_a_row_current.value).to eq 1

      #challenge
      expect(c.challenge_statistic_on_schedule_percentage.reload.value).to eq 0
      expect(c.challenge_statistic_chapters_read.reload.value).to eq 1
      expect(c.challenge_statistic_progress_percentage.reload.value).to eq 50

      #read the second chapter
      click_to_read_a_reading(reading: reading_two, membership: m)
      UpdateStatsWorker.drain

      #individual
      expect(u.user_statistic_chapters_read_all_time.reload.value).to eq 2
      expect(u.user_statistic_days_read_in_a_row_all_time.reload.value).to eq 1
      expect(u.user_statistic_days_read_in_a_row_current.reload.value).to eq 1

      #challenge
      expect(c.challenge_statistic_on_schedule_percentage.reload.value).to eq 0
      expect(c.challenge_statistic_chapters_read.reload.value).to eq 2
      expect(c.challenge_statistic_progress_percentage.reload.value).to eq 100

    end
  end 

  context "Two users in a one chapter challenge" do
    scenario "Creates a challenge and reads through checking stats" do
      create_account_and_log_in(email: 'b@b.com', name: 'B')
      create_a_challenge(name: "One Day", chapters_to_read: "Mat 1")  
      click_link "Logout"
      create_account_and_log_in(email: 'c@c.com', name: 'C')
      c = Challenge.first
      reading = c.readings.first

      visit challenge_path(c)
      click_link "Join Challenge"

      # two users are in the challenge now
      user1, user2 = User.all
      membership1, membership2 = c.membership_for(user1), c.membership_for(user2)

      click_to_read_a_reading(reading: reading, membership: membership2)
      UpdateStatsWorker.drain

      #challenge
      expect(c.challenge_statistic_on_schedule_percentage.reload.value).to eq 0
      expect(c.challenge_statistic_chapters_read.reload.value).to eq 1
      expect(c.challenge_statistic_progress_percentage.reload.value).to eq 50
    end
  end

  context "One user reads all one chapters in the challenge" do
    scenario "When joins a group, also joins the challenge" do
        create_account_and_log_in(email: 'c@c.com', name: 'C')
        create_a_challenge(name: "One Day", chapters_to_read: "Mat 1")  #below
        click_link "Log my reading"

        #job created through updating of reading, now need to push the sidekiq UpdateStatsWorker through
        UpdateStatsWorker.drain

        c = Challenge.first
        expect(c.challenge_statistic_on_schedule_percentage.value).to eq 0
        expect(c.challenge_statistic_chapters_read.value).to eq 1
        expect(c.challenge_statistic_progress_percentage.value).to eq 100

        u = User.first
        expect(u.user_statistic_chapters_read_all_time.value).to eq 1
        expect(u.user_statistic_days_read_in_a_row_all_time.value).to eq 1
        expect(u.user_statistic_days_read_in_a_row_current.value).to eq 1

      click_to_delete_a_reading(membership_reading: MembershipReading.first)
      UpdateStatsWorker.drain

      #challenge
      expect(c.challenge_statistic_on_schedule_percentage.reload.value).to eq 0
      expect(c.challenge_statistic_chapters_read.reload.value).to eq 0
      expect(c.challenge_statistic_progress_percentage.reload.value).to eq 0
    end
  end

  def click_to_delete_a_reading(membership_reading: membership_reading)
    page.driver.submit :delete, "/membership_readings/#{membership_reading.id}.json", {}
    page.driver.status_code.should eql 204
  end

  def click_to_read_a_reading(reading: reading, membership: membership)
    page.driver.post('/membership_readings.json', { :reading_id => reading.id, :membership_id => membership.id  }) 
    page.driver.status_code.should eql 200
  end


  def create_account_and_log_in(email: 'somebody@somebody.com', name: 'Somebody')
    visit new_user_registration_path
    fill_in "user[name]", with: 'Somebody'
    fill_in "Email", with: email
    fill_in "Password", with: '123123'
    fill_in "Password confirmation", with: '123123'

    click_button "Sign up"
  end


  def create_a_challenge(name: "A Challenge", chapters_to_read: "Mat 1")
    visit root_path
    click_link "Create a challenge"
    fill_in "Challenge Name", with: name
    fill_in "challenge[begindate]", with: Date.today
    fill_in "Chapters to Read", with: chapters_to_read
    click_button "Create Challenge"
  end
end

