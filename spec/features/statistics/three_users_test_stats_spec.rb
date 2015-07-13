require 'spec_helper'

feature 'One user reads various parts of a challenge' do

  # this is a pure test that only uses browser actions...

  context "One user reads all one chapters in the challenge" do
    scenario "When joins a group, also joins the challenge" do
        create_account_and_log_in(email: 'c@c.com', name: 'C')
        create_a_challenge(name: "One Day", chapters_to_read: "Mat 1")  #below
        click_link "One Day"  # title of challenge
        click_link "Log my reading"

        #job created through updating of reading, now need to push the sidekiq UpdateStatsWorker through
        UpdateStatsWorker.drain

        c = Challenge.first
        expect(c.challenge_statistic_on_schedule_percentage.value).to eq '0'
        expect(c.challenge_statistic_chapters_read.value).to eq '1'
        expect(c.challenge_statistic_progress_percentage.value).to eq '100'

        u = User.first
        expect(u.user_statistic_chapters_read_all_time.value).to eq "1"
        expect(u.user_statistic_days_read_in_a_row_all_time.value).to eq "1"
        expect(u.user_statistic_days_read_in_a_row_current.value).to eq "1"

    end
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

