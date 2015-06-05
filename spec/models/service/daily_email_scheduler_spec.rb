require 'spec_helper'

describe DailyEmailScheduler do
  describe "self.set_daily_email_jobs" do
    it "schedules an email job for a user" do
      user = create(:user, :with_profile)
      challenge = create(:challenge, :with_readings, begindate: "2050-01-01")
      create(:membership, user: user, challenge: challenge)

      Timecop.travel("2050-01-01")

      DailyEmailScheduler.set_daily_email_jobs

        binding.pry
      expect(DailyEmailWorker.jobs.size).to eq 1

      Timecop.return
    end

    it "schedules an email according to the user's preferences for a user" do
      #include ActiveJob::TestHelper
      today = Date.now
      user1 = create(:user, :with_profile) #time_zone: "UTC", preferred_reading_hour: 6
      user2 = create(:user, profile: create(:profile, time_zone: "EST",
                                           preferred_reading_hour: 8))
      challenge = create(:challenge, :with_readings)
      create(:membership, user: user1, challenge: challenge)
      create(:membership, user: user2, challenge: challenge)

      t = Time.local(today, 9, 1, 10, 5, 0)
      Timecop.travel(1.days)

      DailyEmailScheduler.set_daily_email_jobs
      binding.pry
      #expect(DailyEmailWorker.method :perform).to be_delayed(DailyEmailWorker).for 6.hour
      
      Timecop.return
    end
  end



end

