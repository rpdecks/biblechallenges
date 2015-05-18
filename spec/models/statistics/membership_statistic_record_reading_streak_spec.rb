require 'spec_helper'

# Manny I don't even know what this statistic is measuring.  Does "record" mean "all-time?" if so
# we should change the name because record as a verb causes some confusion.

describe MembershipStatisticRecordReadingStreak do
  describe "#calculate" do
    it "should calculate the proper value even when user reads several times in one day" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 3.days)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: first_day + 4.days)
      # streak of 2

      Timecop.travel(first_day + 4.days)

      stat = MembershipStatisticRecordReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 2
      Timecop.return
    end

    it "calculates value when the streak is in the past" do
      Timecop.travel(8.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 2)

      Timecop.freeze(first_day + 5.days)
      stat = MembershipStatisticRecordReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 3
      Timecop.return
    end

    it "calculates value of reading streak when a reading is logged on each challenge day" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 2)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 3)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: first_day + 4)
      Timecop.freeze(first_day + 5.days)
      stat = MembershipStatisticRecordReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 5
      Timecop.return
    end

    it "calculates value of reading streak when no reading occurs on the first day" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 2)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 3)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 4)
      Timecop.freeze(first_day + 5.days)
      stat = MembershipStatisticRecordReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 4
      Timecop.return
    end

  end

end
