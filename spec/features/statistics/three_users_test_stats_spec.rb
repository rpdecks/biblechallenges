require 'spec_helper'

feature 'One user reads various parts of a challenge' do

  # this is a pure test that only uses browser actions...

  context "One user reads various amounts of chapters in the challenge" do
    scenario "Creates a challenge and reads nothing" do

      create_account_and_log_in(email: 'c@c.com', name: 'C')
      create_a_challenge(name: "One Day", chapters_to_read: "Mat 1-2")  #below

      # the challenge stats should exist, and be zeroed
      c = Challenge.first
      u = User.first
      m = c.membership_for(u)
#      expect(c.challenge_statistic_on_schedule_percentage.value).to eq '0'
#      expect(c.challenge_statistic_chapters_read.value).to eq '0'
#      expect(c.challenge_statistic_progress_percentage.value).to eq '0'

      reading_one, reading_two = c.readings
      click_link "One Day"  # title of challenge

      #  This is a terrible thing.  I can't simulate clicking on the checkboxes,
      #  I think because they are react components.  So simulating the post action
      #  is as close as I can get to being a "real" user action
      #  This is clicking one box
      page.driver.post('/membership_readings.json', { :reading_id => reading_one.id, :membership_id => m.id  }) 
      page.driver.status_code.should eql 200

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

