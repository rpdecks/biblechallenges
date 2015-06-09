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
  end
end

