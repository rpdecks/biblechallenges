class DailyEmailScheduler

  def self.set_daily_email_jobs
    # what we need is a collection of readings per user per challenge to pass
    # to the daily email worker

    #tomorrows_readings = Reading.tomorrows_readings
    tomorrows_challenges = Challenge.with_readings_tomorrow

    tomorrows_challenges.each do |challenge|
      tomorrows_reading_ids = challenge.readings.tomorrows_readings.pluck(:id)
      challenge.members.each do |m|

        #set time_zone to the user's time_zone
        Time.zone = m.time_zone

        #convert user_time to UTC
        user_reading_hour = m.preferred_reading_hour

        # e.g. format => "2050-05-02 07:00:00"
        user_reading_hour_string = DateTime.tomorrow.strftime("%Y-%m-%d") + " " + user_reading_hour.to_s + ":00:00"
        user_reading_hour_utc = Time.zone.parse(user_reading_hour_string).utc

        if m.reading_notify == true
          EmailLog.create(event: "Schedule", membership_id: m.id)
          DailyEmailWorker.perform_at(user_reading_hour_utc.to_i,
                                      tomorrows_reading_ids,
                                      m.id)
        end
      end
    end
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
