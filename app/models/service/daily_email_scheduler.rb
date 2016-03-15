class DailyEmailScheduler

  def self.set_daily_email_jobs
    begin_time = Time.current
    # what we need is a collection of readings per user per challenge to pass
    # to the daily email worker
    task_errors = []
    #tomorrows_readings = Reading.tomorrows_readings
    tomorrows_challenges = Challenge.with_readings_tomorrow
    total_challenges = 0
    total_members = 0
    total_emails_send = 0
    Time.zone = "UTC"
    utc_date_tomorrow = DateTime.current.tomorrow
    tomorrows_challenges.each do |challenge|
      total_challenges += 1
      tomorrows_reading_ids = challenge.readings.tomorrows_readings.pluck(:id)
      challenge.members.each do |m|
        total_members += 1
        begin
        #set time_zone to the user's time_zone
          Time.zone = m.time_zone

          #convert user_time to UTC
          user_reading_hour = m.preferred_reading_hour

          # e.g. format => "2050-05-02 07:00:00"
          user_reading_hour_string = utc_date_tomorrow.strftime("%Y-%m-%d") + 
            " " + user_reading_hour.to_s + ":00:00"
          user_reading_hour_utc = Time.zone.parse(user_reading_hour_string).utc

          if m.reading_notify == true
            EmailLog.create(event: "Schedule",
                            challenge_id: challenge.id,
                            user_id: m.id,
                            email: m.email,
                            time_zone: m.time_zone,
                            preferred_reading_hour: m.preferred_reading_hour,
                            schedule_time: user_reading_hour_utc)

            DailyEmailWorker.perform_at(user_reading_hour_utc.to_i,
                                        tomorrows_reading_ids,
                                        m.id)
            total_emails_send += 1
          end
        rescue => ex
          task_errors << ex.message
        end
      end
    end
    Time.zone = "UTC"
    end_time = Time.current
    exec_time = (end_time - begin_time)/60
    TaskStat.daily_email_stat(total_challenges,total_members,total_emails_send,task_errors,begin_time,end_time,exec_time.round(1)).deliver_now
  end

  def self.set_daily_email_jobs2(a_date)
    # assume we are sending emails for some date passed in
    todays_readings = Reading.where(read_on: a_date)
    # now we have all the readings in the system that are scheduled today
    todays_readings.each do |reading|
      # find all the members for this reading
      reading.members.each do |member|
        # when exactly should the email be scheduled
        time_for_email = ZoneConverter.new.time_from_hour_date_and_zone(member.preferred_reading_hour, reading.read_on, member.time_zone)
        # schedule the email
        DailyEmailWorker.perform_at(time_for_email, reading.id, member.id)
      end
    end
  end

end