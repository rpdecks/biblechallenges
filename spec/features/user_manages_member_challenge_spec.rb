require 'spec_helper'

feature 'User manages member/challenge' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario "User is able to see Todays reading", :js => true do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    within('.chapter') do
      expect(page).to have_content("Matthew 1")
    end
  end

  scenario "User is able to log todays reading" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    click_link "Log #{challenge.readings.first.book_and_chapter}"
    expect(MembershipReading.count).to eq 1
  end

  scenario "User is able to see Todays reading when timezone is blank" do
    user.time_zone = ""
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    within('.chapter') do
      expect(page).to have_content("Matthew 1")
    end
  end

  scenario "Today's reading accounts for Timezone" do
    user.time_zone = "Paris"

    Time.zone = "Eastern Time (US & Canada)"
    creation_time = Time.local(2015, 7, 4, 10, 0, 0) # time challenge was created
    Timecop.travel(creation_time)
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-3")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)

    read_time = Time.local(2015, 7, 5, 23, 0, 0) # a day later, at night
    Timecop.travel(read_time)
    visit member_challenge_path(challenge)

    within('.chapter') do
      expect(page).to_not have_content("Matthew 2")
      expect(page).to have_content("Matthew 3")
    end

    Timecop.return
  end

  scenario "Today's reading accounts for multiple readings per day"
end
