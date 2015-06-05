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
      include ActiveJob::TestHelper
      user = create(:user, profile: create(:profile, time_zone: "UTC",
                                           preferred_reading_hour: 6))
      challenge = create(:challenge, :with_readings, begindate: "2050-06-01")
      create(:membership, user: user, challenge: challenge)

      Timecop.travel("2050-06-01")
      DailyEmailScheduler.set_daily_email_jobs
      binding.pry
      enqueued_jobs
      expect(DailyEmailWorker.method :perform).to be_delayed(DailyEmailWorker).for 6.hour
    end
  end



end

