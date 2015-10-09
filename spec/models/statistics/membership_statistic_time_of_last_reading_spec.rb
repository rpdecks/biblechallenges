require 'spec_helper'

describe MembershipStatisticTimeOfLastReading do

  describe "#calculate" do

    it "returns nil if there are no readings" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-2')
      membership = create(:membership, challenge: challenge, user: create(:user))

      stat = MembershipStatisticTimeOfLastReading.new(membership: membership)
      expect(stat.calculate).to eq nil
    end


    it "calculates the time of the most recent membership_reading for this membership" do
      old_date_of_reading = Date.parse("2000-10-10")
      most_recent_date_of_reading = DateTime.new(2050,10,10)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-2')
      membership = create(:membership, challenge: challenge, user: create(:user))

      create(:membership_reading, 
             reading: challenge.readings.first, membership: membership,
            created_at: old_date_of_reading)

      create(:membership_reading, 
             reading: challenge.readings.last, membership: membership,
            created_at: most_recent_date_of_reading)

      stat = MembershipStatisticTimeOfLastReading.new(membership: membership)
      expect(stat.calculate).to eq most_recent_date_of_reading
    end
  end
end

