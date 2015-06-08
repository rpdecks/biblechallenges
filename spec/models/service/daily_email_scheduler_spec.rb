require 'spec_helper'

describe DailyEmailScheduler do
  describe "self.set_daily_email_jobs" do
    it "schedules an email job for a user" do
      user = create(:user, :with_profile)
      challenge = create(:challenge, :with_readings, begindate: "2050-01-01")
      create(:membership, user: user, challenge: challenge)

      Timecop.travel("2050-01-01")

      DailyEmailScheduler.set_daily_email_jobs

      expect(DailyEmailWorker.jobs.size).to eq 1

      Timecop.return
    end

    it "schedules an email according to the user's preferences for a user" do
      today = DateTime.now
      user1 = create(:user, profile: create(:profile, time_zone: "EST",
                                           preferred_reading_hour: 7))
      user2 = create(:user, profile: create(:profile, time_zone: "Pacific Time (US & Canada)",
                                           preferred_reading_hour: 7))
      challenge = create(:challenge, :with_readings, begindate: today)
      create(:membership, user: user1, challenge: challenge)
      create(:membership, user: user2, challenge: challenge)

      #traveling to next day 0-hours
      t = Time.local(today.year, today.month, today.day + 1, 0, 0, 0)
      Timecop.travel(t)

      DailyEmailScheduler.set_daily_email_jobs
      a = Time.at(DailyEmailWorker.jobs.first["at"])
      b = Time.at(DailyEmailWorker.jobs.last["at"])
      time_lapse = ( b -a ) / 3600
      expect(time_lapse).to eq 3
      
      Timecop.return
    end
  end



end

