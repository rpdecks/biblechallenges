require 'spec_helper'

describe DailyEmailScheduler do
  describe "self.set_daily_email_jobs" do
    it "schedules an email job for a user" do
      #Membership.delete_all  #todo this should not be necesssary
      user = create(:user, :with_profile)
      challenge = create(:challenge, :with_readings, begindate: "2050-01-01", owner: user)
      create(:membership, user: user, challenge: challenge)

      Timecop.travel("2050-01-01")

      DailyEmailScheduler.set_daily_email_jobs

      expect(DailyEmailWorker.jobs.size).to eq 1

      Timecop.return
    end

    it "schedules email's timing according to the user's preferences" do
      today = DateTime.now
      user1 = create(:user, profile: create(:profile, time_zone: "Eastern Time (US & Canada)",
                                           preferred_reading_hour: 7))
      user2 = create(:user, profile: create(:profile, time_zone: "Pacific Time (US & Canada)",
                                           preferred_reading_hour: 7))
      challenge = create(:challenge, :with_readings, begindate: today, owner: user1)
      create(:membership, user: user1, challenge: challenge)
      create(:membership, user: user2, challenge: challenge)

      #traveling to next day 0-hours
      Time.zone = "UTC"
      t = Time.local(today.year, today.month, today.day, 20, 0, 0)
      Timecop.travel(t)

      DailyEmailScheduler.set_daily_email_jobs

      a = Time.at(DailyEmailWorker.jobs.first["at"])
      b = Time.at(DailyEmailWorker.jobs.last["at"])
      time_lapse = ( b - a ) / 3600

      expect(time_lapse).to eq 3

      Timecop.return
    end

    it "schedules tomorrows reading according to the user's preferences" do
      today = DateTime.now
      user1 = create(:user, profile: create(:profile, time_zone: "Eastern Time (US & Canada)",
                                           preferred_reading_hour: 7))
      challenge = create(:challenge, :with_readings, begindate: today)
      create(:membership, user: user1, challenge: challenge)

      #traveling to next day 0-hours
      Time.zone = "UTC"
      t = Time.local(today.year, today.month, today.day, 20, 0, 0)
      Timecop.travel(t)

      DailyEmailScheduler.set_daily_email_jobs

      reading_id_a = Time.at(DailyEmailWorker.jobs.first["args"][0])
      reading_date_a = Reading.find(reading_id_a).read_on.strftime("%D")

      tomorrow = DateTime.now+1
      expect(reading_date_a).to eq tomorrow.strftime("%D")

      Timecop.return
    end
  end


  describe "set_daily_email_jobs2" do  # another approach
    it "schedules an email job for two users with the same hour preference in different timezones" do
      challenge = create(:challenge, :with_readings, begindate: "2050-01-01")
      create(:membership, user: user_7am_eastern_time, challenge: challenge)
      create(:membership, user: user_7am_pacific_time, challenge: challenge)

      todays_date = Date.parse("2050-01-01")
      DailyEmailScheduler.set_daily_email_jobs2(todays_date)
      a = Time.at(DailyEmailWorker.jobs.first["at"])
      b = Time.at(DailyEmailWorker.jobs.last["at"])
      time_lapse = ( b - a ) / 3600
      expect(time_lapse).to eq 3
    end
    it "schedules an email job for users in different timezones but at the same scheduled universal time" do
      challenge = create(:challenge, :with_readings, begindate: "2050-01-01")
      create(:membership, user: user_7am_eastern_time, challenge: challenge)
      create(:membership, user: user_4am_pacific_time, challenge: challenge)

      todays_date = Date.parse("2050-01-01")
      DailyEmailScheduler.set_daily_email_jobs2(todays_date)
      a = Time.at(DailyEmailWorker.jobs.first["at"])
      b = Time.at(DailyEmailWorker.jobs.last["at"])
      
      expect(a).to eq b
    end
  end





  def user_4am_pacific_time
    create(:user, profile: create(:profile, time_zone: "Pacific Time (US & Canada)", preferred_reading_hour: 4))
  end

  def user_7am_pacific_time
    create(:user, profile: create(:profile, time_zone: "Pacific Time (US & Canada)", preferred_reading_hour: 7))
  end

  def user_7am_eastern_time
    create(:user, profile: create(:profile, time_zone: "Eastern Time (US & Canada)", preferred_reading_hour: 7))
  end



end

