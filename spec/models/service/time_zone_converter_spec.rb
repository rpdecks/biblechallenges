require 'spec_helper'

#upcase look at this with a coach; can it be better?
describe TimeZoneConverter do

  describe "#time_from_hour_date_and_zone" do
    describe "returns a specific point in time given an hour, date, and timezone" do
      it "returns 12:00am for UTC timezone on a given date" do
        timezone = "Eastern Time (US & Canada)"
        hour = 12
        date = Date.parse("2050-01-01")

        result = TimeZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone)

        expect(result.hour).to eq 12
        expect(result.mon).to eq 1
        expect(result.year).to eq 2050
      end
      it "the same time in two adjacent zones should be an hour apart" do
        timezone1 = "Central Time (US & Canada)"
        timezone2 = "Eastern Time (US & Canada)"
        hour = 12
        date = Date.parse("2050-01-01")

        result1 = TimeZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone1)
        result2 = TimeZoneConverter.new.time_from_hour_date_and_zone(hour, date, timezone2)

        expect(result1.utc.hour - result2.utc.hour).to eq 1
      end
    end
  end


end
