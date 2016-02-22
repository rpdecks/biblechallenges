require 'spec_helper'

feature 'User views challenge page as member' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario "User is able to see Todays reading" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    within('.chapter') do
      expect(page).to have_content("Matthew 1")
    end
  end

# Valid/working text, but has too heavy a call to LSM API for RcV text
#  scenario "only sends number of chapters up to the daily limit of readings" do
#    challenge = create(:challenge, :with_readings, begindate: Date.today, enddate: Date.today,
#                      chapters_to_read: "Gen 1-33")
#    create(:membership, user: user, challenge: challenge, bible_version: "RCV")
#    visit member_challenge_path(challenge)
#
#    expect(page).to have_content "a good dowry"  # from Gen 30
#    expect(page).not_to have_content "spent the night in the mountain"  #from Gen 31
#  end

  scenario "Today's reading accounts for multiple readings per day" do
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-2",
                       begindate: Date.today,
                       enddate: Date.today)
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)
    visit member_challenge_path(challenge)
    within all(".chapter")[0] do
      expect(page).to have_content("Matthew 1")
    end
    within all(".chapter")[1] do
      expect(page).to have_content("Matthew 2")
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

  scenario "Today's reading date accounts for Timezone" do
    user.time_zone = "Paris"

    # create a challenge
    Time.zone = "Eastern Time (US & Canada)"
    creation_time = Time.zone.local(2015, 7, 4, 10, 0, 0) # time challenge was created
    Timecop.travel(creation_time)
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-3")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)

    # user visits challenge show page
    read_time = Time.zone.local(2015, 7, 5, 23, 0, 0) # a day later, at night
    Timecop.travel(read_time)
    visit member_challenge_path(challenge)

    expect(page).to have_content(
      "Today's Reading (#{Time.now.in_time_zone(user.time_zone).strftime("%m/%d/%Y")})")

    Timecop.return
  end

  scenario "Today's reading chapter accounts for Timezone" do
    user.time_zone = "Paris"

    # create a challenge
    Time.zone = "Eastern Time (US & Canada)"
    creation_time = Time.local(2015, 7, 4, 10, 0, 0) # time challenge was created
    Timecop.travel(creation_time)
    challenge = create(:challenge_with_readings, chapters_to_read: "Matthew 1-3")
    ChallengeCompletion.new(challenge)
    create(:membership, challenge: challenge, user: user)

    # user visits challenge show page
    read_time = Time.local(2015, 7, 5, 23, 0, 0) # a day later, at night
    Timecop.travel(read_time)
    visit member_challenge_path(challenge)

    within('.chapter') do
      expect(page).to_not have_content("Matthew 2")
      expect(page).to have_content("Matthew 3")
    end

    Timecop.return
  end
end
