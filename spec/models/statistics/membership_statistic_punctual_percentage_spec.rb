require 'spec_helper'

describe MembershipStatisticPunctualPercentage do

  describe "#calculate" do

    it "should calculate a perfect percentage" do
      # four chapters each read on the right day
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: 'Matt 1-4', begindate: Date.today)

      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date
      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 1.days)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 2.days)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 3.days)

      Timecop.travel(first_day + 3.days)

      stat = MembershipStatisticPunctualPercentage.new(membership: membership)
      expect(stat.calculate).to eq 100
      Timecop.return
    end
  end

end
