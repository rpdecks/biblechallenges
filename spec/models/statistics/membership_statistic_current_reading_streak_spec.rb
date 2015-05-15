require 'spec_helper'

describe MembershipStatisticCurrentReadingStreak do
  describe "#calculate" do
    it "should calculate the proper value even when user reads several times in one day" do
      Timecop.travel(8.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)

      membership.membership_readings[1].update_attributes(state: "read", updated_at: DateTime.now)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(3.day)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(2.day)
      Timecop.travel(1.day)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[5].update_attributes(state: "read", updated_at: DateTime.now)
      membership.membership_readings[6].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[7].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.return

      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 3
    end

    it "calculates value even if user has not read in a while" do
      Timecop.travel(8.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)

      membership.membership_readings[1].update_attributes(state: "read", updated_at: DateTime.now)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(3.day)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(2.day)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[5].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      Timecop.travel(1.day)
      membership.membership_readings[6].update_attributes(state: "read", updated_at: DateTime.now)
      membership.membership_readings[7].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.return

      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 1
    end

    it "calculates value of reading streak when all days are read" do
      Timecop.travel(8.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)
      Timecop.travel(1.day)
      membership.membership_readings[0].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[5].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[6].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[7].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.return

      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 8
    end

    it "calculates value of reading streak when first day is not read" do
      Timecop.travel(8.days.ago)
      challenge = create(:challenge_with_readings, chapters_to_read: 'Matt 1-20')
      membership = create(:membership, challenge: challenge)
      Timecop.travel(1.day)
      Timecop.travel(1.day)
      membership.membership_readings[1].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[2].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[3].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[4].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[5].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[6].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.travel(1.day)
      membership.membership_readings[7].update_attributes(state: "read", updated_at: DateTime.now)
      Timecop.return

      stat = MembershipStatisticCurrentReadingStreak.new(membership: membership)
      expect(stat.calculate).to eq 7
    end
  end

end
