class DailyEmailScheduler

  def self.set_daily_email_jobs
    Membership.all.each do |m|
      reading = m.readings.todays_reading.first

      #set time_zone to the user's time_zone
      user_time_zone = m.user.profile.time_zone
      Time.zone = user_time_zone

      #convert user_time to UTC
      user_reading_hour = m.user.profile.preferred_reading_hour
      user_reading_hour_string = DateTime.now.strftime("%Y-%m-%d") + " " + user_reading_hour.to_s + ":00:00"  # --> "2050-05-02 07:00:00"
      user_reading_hour_utc = Time.zone.parse(user_reading_hour_string).utc

      #schedule the sidekiq job

      if reading #schedule may be done, but still active
        DailyEmailWorker.perform_at(user_reading_hour_utc.to_i, reading.id, m.user.id)
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
        time_for_email = TimeZoneConverter.new.time_from_hour_date_and_zone(member.profile.preferred_reading_hour, reading.read_on, member.profile.time_zone)
        # schedule the email
        DailyEmailWorker.perform_at(time_for_email, reading.id, member.id)
      end
    end
  end

end
