require 'spec_helper'

describe DateRangeParser do

  describe "valid input" do
    begin_date = "2020-01-01"
    end_date = "2020-01-02"

    it "returns a single range array when given a single range string" do
      date_range_array = DateRangeParser.new("#{begin_date}..#{end_date}").ranges
      expect(date_range_array).to match_array [Date.parse(begin_date)..Date.parse(end_date)]
    end

  end

  describe "invalid input" do

  end



end

