require 'spec_helper'

describe ReadingsGenerator do

  describe '#generate' do
    describe "Generates the correct number of readings" do
      it "Generates 5 readings when given Matt 1-5" do
        begindate = Date.parse "2050-01-01"

        readings = ReadingsGenerator.new(begindate, "Matthew 1-5").generate

        expect(readings.size).to eq 5
      end
      it "Generates 4 readings when given Gen1, Luke1-2, Rev 3" do
        begindate = Date.parse "2050-01-01"

        readings = ReadingsGenerator.new(begindate, "Gen 1, Luke1-2, Rev 3").generate

        expect(readings.size).to eq 4
      end
    end

    describe "Generates readings on the correct days" do
      it "Generates the first reading on begindate" do
        begindate = Date.parse "2050-01-01"

        readings = ReadingsGenerator.new(begindate, "Matthew 1-3").generate

        expect(readings.first.read_on).to eq begindate
      end

      it "Generates the last reading on the correct day" do
        begindate = Date.parse "2050-01-01"

        readings = ReadingsGenerator.new(begindate, "Matthew 1-3").generate

        expect(readings.last.read_on).to eq Date.parse("2050-01-03")
      end
    end


    describe "Skips days of the week correctly" do
      it "skips the first day of the challenge when the challenge starts on a skip day" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday

        readings = ReadingsGenerator.new(begindate, "Matthew 1-3", days_of_week_to_skip: [6]).generate

        expect(readings.first.read_on).to eq Date.parse("2050-01-02")
        expect(readings.size).to eq 3
      end
      it "Schedules only on Mondays when we exclude the other days" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday

        readings = ReadingsGenerator.new(begindate, "Matthew 1-5", days_of_week_to_skip: [0,2,3,4,5,6]).generate

        expect(readings.size).to eq 5
        readings.each do |r|
          expect(r.read_on.wday).to eq 1
        end
      end

      it "does not create readings for selected date ranges" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday
        readings = ReadingsGenerator.new(begindate, "Matthew 1-5", date_ranges_to_skip: ["2050-01-02..2050-01-07"]).generate

        expect(readings.last.read_on).to eq Date.parse("2050-01-11")
        expect(readings.size).to eq 5
      end

      it "does not create readings for selected skip date ranges and days of week" do
        begindate = Date.parse "2050-01-14"  # this is a Friday
        readings = ReadingsGenerator.new(begindate, "Matthew 1-5", days_of_week_to_skip: [6,0], date_ranges_to_skip: ["2050-01-17..2050-01-20"]).generate  # skipping weekends(Sat-Sun) & next Mon-Thu(date-range)

        expect(readings.first.read_on).to eq Date.parse("2050-01-14")
        expect(readings.second.read_on).to eq Date.parse("2050-01-21")
        expect(readings.size).to eq 5
      end
    end
  end
end

