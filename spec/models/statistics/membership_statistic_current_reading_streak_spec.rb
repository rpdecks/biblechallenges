require 'spec_helper'

# I think we are going to have some issues with this statistic because we shouldn't 
# 'break' the person's streak until an entire day has elapsed with no reading.

# for example, if I've read for the past 3 days, and today is day 4, and I have not read yet
# my streak should be 3, not zero.  I think our stats are mostly correct but somehow need to
# account for allowing a streak to exist even though the present day's reading is not entered.

describe MembershipStatisticCurrentReadingStreak do
  describe "#calculate" do
    it "should calculate the proper value even when user reads several times in one day" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      # challenge has five days, read 1,0,0,2,1, checking on the last day,  giving a streak of 2
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 3.days)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 3.days)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 4.days)
      Timecop.travel(first_day + 4.days)
      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)

      expect(stat.calculate).to eq 2
      Timecop.return # is this necessary?
    end

    it "should calculate the proper value even when user is behind" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      # reading will skip the first day but then proceed daily, so on day four of the 
      # challenge the user should have a 3 day streak

      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day+ 2)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 3)
      Timecop.travel(first_day + 3.days)  # day 4
      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)

      expect(stat.calculate).to eq 3
      Timecop.return # is this necessary?
    end

    it "should calculate the proper value even when user is ahead" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date
      # user reads all 5 chapters in first three days.  stat measured on day 3

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: first_day + 2)
      Timecop.travel(first_day + 2)
      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)

      expect(stat.calculate).to eq 3
      Timecop.return # is this necessary?
    end

    it "calculates streak of 1 when user resumes today" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date

      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: first_day + 4.days)
      Timecop.travel(first_day + 4)
      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)

      expect(stat.calculate).to eq 1
      Timecop.return # is this necessary?
    end

    it "calculates value of reading streak when all days are read" do
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-5')
      membership = create(:membership, challenge: challenge)
      first_day = challenge.readings.order(:date).first.date
      membership.membership_readings[0].update_attributes(state: "read", updated_at: first_day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: first_day + 1)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: first_day + 2)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: first_day + 3)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: first_day + 4)
      Timecop.travel(first_day + 4)
      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)

      expect(stat.calculate).to eq 5
      Timecop.return # is this necessary?
    end

  end


end
