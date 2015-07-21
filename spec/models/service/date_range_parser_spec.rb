require 'spec_helper'

describe DateRangeParser do

  describe "valid input" do
    begin_date = "2020-01-01"
    end_date = "2020-01-02"
    begin_date2 = "2020-04-01"
    end_date2 = "2020-04-02"

    it "returns a single range array when given a single range string" do
      date_range_array = DateRangeParser.new("#{begin_date}..#{end_date}").ranges
      expect(date_range_array).to match_array [Date.parse(begin_date)..Date.parse(end_date)]
    end

    it "returns an array of date ranges when given a range string separated by commas" do
      range_string = "#{begin_date}..#{end_date}, #{begin_date2}..#{end_date2}"
      date_range_array = DateRangeParser.new(range_string).ranges
      expect(date_range_array).to match_array [
        Date.parse(begin_date)..Date.parse(end_date), 
        Date.parse(begin_date2)..Date.parse(end_date2)
      ]
    end
  end

  describe "invalid input" do
    it "returns an empty array for nil" do
      date_range_array = DateRangeParser.new(nil).ranges
      expect(date_range_array).to match_array []
    end
    it "sets an @error when it can't parse the range and returns an empty array" do
      parser = DateRangeParser.new('bleah')
      date_range_array = parser.ranges
      expect(date_range_array).to match_array []
      expect(parser.error).to eq "Error with date range"
    end
    it "sets an @error when it can't parse the entire range and returns an array with only what it could parse" do
      begin_date = "2020-01-01"
      end_date = "2020-01-02"
      parser = DateRangeParser.new("#{begin_date}..#{end_date}, bleah")
      date_range_array = parser.ranges
      expect(date_range_array).to match_array [Date.parse(begin_date)..Date.parse(end_date)]
      expect(parser.error).to eq "Error with date range"
    end

  end


end

