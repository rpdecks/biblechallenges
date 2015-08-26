require 'spec_helper'

describe FrontPageLeaderboard do

  it "correctly displays the most-read chapter(s) for the previous week" do
  let(:challenge) { build(:challenge, chapters_to_read: "Matt 1-5") }
    challenge = create(:challenge, chapters_to_read: "Matt 1-5")
    challenge.generate_readings
    user = User.first
    user2 = create(:user)
    membership = challenge.join_new_member(user)
    membership2 = challenge.join_new_member(user2)
    create_list(:membership_reading, 2


    result = AvailableDatesCalculator.new(challenge).available_dates

    expect(result.size).to eq 5
    (challenge.begindate..(challenge.begindate + 4.days)).to_a.each do |a_date|
      expect(result).to include a_date
    end
  end
end
