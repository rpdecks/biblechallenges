class ZoneConverter

  def time_from_hour_date_and_zone(hour, date, timezone)
    Time.zone = timezone
    Time.zone.local(date.year, date.month, date.day, hour)
  end

  def on_date_in_zone?(date: nil, timestamp: nil, timezone: nil)
    local_read_on_date = timestamp.in_time_zone(timezone).to_date
    local_read_on_date == date
  end
end
