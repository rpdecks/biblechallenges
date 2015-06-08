class TimeZoneConverter

  def time_from_hour_date_and_zone(hour, date, timezone)
    Time.zone = timezone
    Time.zone.local(date.year, date.month, date.day, hour)
  end
end
