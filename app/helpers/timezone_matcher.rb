module TimezoneMatcher
  def self.foo(wday, hour, time = Time.current)
    zones = ActiveSupport::TimeZone.all
    zones.select { |z|
      t = time.in_time_zone(z)
      t.wday == wday && t.hour == hour
    }.map(&:tzinfo).map(&:name)
  end
end
