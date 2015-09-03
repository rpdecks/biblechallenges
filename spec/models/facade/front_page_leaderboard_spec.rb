require 'spec_helper'

describe FrontPageLeaderboard do

  it "correctly displays the most-read chapter(s) for the previous week" do
    challenge = create(:challenge, chapters_to_read: "Matt 1-5")
    challenge.generate_readings
    reading1 = create(:reading, chapter_id: 930) #Matt 1
    reading2 = create(:reading, chapter_id: 931)
    reading3 = create(:reading, chapter_id: 932)
    reading4 = create(:reading, chapter_id: 933)
    user = User.first
    user2 = create(:user)
    user3 = create(:user)
    membership = challenge.join_new_member(user)
    membership2 = challenge.join_new_member(user2)
    membership3 = challenge.join_new_member(user3)
    
    create(:membership_reading, membership: membership, reading: reading1) #3 users read Matt 1
    create(:membership_reading, membership: membership2, reading: reading1)
    create(:membership_reading, membership: membership3, reading: reading1)

    Timecop.travel(8.days)

    create(:membership_reading, membership: membership, reading: reading2) #2 users read Matt 2
    create(:membership_reading, membership: membership3, reading: reading2)

    create(:membership_reading, membership: membership, reading: reading3) #1 user reads Matt 3

    create(:membership_reading, membership: membership2, reading: reading4) #2 users read Matt 4
    create(:membership_reading, membership: membership3, reading: reading4)

    @front_page_leaderboard = FrontPageLeaderboard.new
    result = @front_page_leaderboard.weeks_most_read_chapter
    Timecop.return
    expect(result).to eq "Matthew 2 and Matthew 4"
  end
end
