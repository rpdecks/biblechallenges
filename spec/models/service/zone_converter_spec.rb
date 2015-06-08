require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe ZoneConverter do

  describe "#time_from_hour_date_and_zone" do
    describe "returns a specific point in time given an hour, date, and timezone" do
      it "returns 12:00am for UTC timezone on a given date" do
        timezone = "Eastern Time (US & Canada)"
        hour = 12
        date = Date.parse("2050-01-01")

        result = ZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone)

        expect(result.hour).to eq 12
        expect(result.mon).to eq 1
        expect(result.year).to eq 2050
      end
      it "the same time in two adjacent zones should be an hour apart" do
        timezone1 = "Central Time (US & Canada)"
        timezone2 = "Eastern Time (US & Canada)"
        hour = 12
        date = Date.parse("2050-01-01")

        result1 = ZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone1)
        result2 = ZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone2)

        expect(result1.utc.hour - result2.utc.hour).to eq 1
      end
    end
  end

  describe "#on_date_in_zone?" do
    describe "returns true or false if the given timestamp was on the given date for the given timezone" do
      # The timestamp being measured is 1am Eastern Time on 2050-01-02.  
      # We check to see if this timestamp is "on_date_in_zone" for eastern and pacific timezones for 
      # the previous day (2050-01-01).  It should return false for eastern timezone and true for pacific,
      # because the timestamp was on 2050-01-01 10pm pacific time.

      it "correctly adjust for timezones when calculated on_date_in_zone" do
        eastern_tz = "Eastern Time (US & Canada)"
        pacific_tz = "Pacific Time (US & Canada)"
        jan1 = Date.parse("2050-01-01")
        jan2 = Date.parse("2050-01-02")

        eastern_1am_jan2_timestamp  = ZoneConverter.new.time_from_hour_date_and_zone(1, jan2, eastern_tz)

        expect(ZoneConverter.new.on_date_in_zone?(date: jan1, timestamp: eastern_1am_jan2_timestamp, timezone: eastern_tz)).to be false
        expect(ZoneConverter.new.on_date_in_zone?(date: jan1, timestamp: eastern_1am_jan2_timestamp, timezone: pacific_tz)).to be true
        expect(ZoneConverter.new.on_date_in_zone?(date: jan2, timestamp: eastern_1am_jan2_timestamp, timezone: eastern_tz)).to be true
      end

    end
  end

end
