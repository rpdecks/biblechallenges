module TimezoneMatcher
  def timezones_where_the_day_and_hour_are(wday, hour, time = Time.current)
    binding.pry
    zones = ActiveSupport::TimeZone.all
    zones.select { |z|
      t = time.in_time_zone(z)
      t.wday == wday && t.hour == hour
    }.map(&:tzinfo).map(&:name)
  end

end
