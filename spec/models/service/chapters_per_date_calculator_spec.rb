require 'spec_helper'

describe ChaptersPerDateCalculator do

  # should produce a hash with dates as keys and numbers of chapters for those dates as values

  # required options passed in are begindate, num_chapters
  # optional are enddate, num_chapters_per_day, dates_to_skip, and days_of_week_to_skip

  describe "helper methods" do
    describe "find_available_days" do

      it "calculates successfully with no special options" do
        begindate = Date.parse("2050-01-01")
        result = ChaptersPerDateCalculator.new(num_chapters: 5, begindate: begindate).find_available_days

        expect(result.size).to eq 5  # 5 unique days

        # should be a hash entry for five days in a row
        (begindate..Date.parse("2050-01-05")).to_a.each do |a_date|
          expect(result[a_date]).to_not be_nil
        end
      end

      it "calculates successfully with days_to_skip" do
        begindate = Date.parse("2050-01-01")  # this is a saturday
        sat_sunday = [6,0]
        result = ChaptersPerDateCalculator.new(num_chapters: 5, begindate: begindate,
                                              days_of_week_to_skip: sat_sunday).find_available_days

        expect(result.size).to eq 5  # 5 unique days
        expect(result[begindate]).to be_nil

        # should be a hash entry for five days in a row starting two days (monday) after begindate
        ((begindate + 2.days)..Date.parse("2050-01-07")).to_a.each do |a_date|
          expect(result[a_date]).to_not be_nil
        end
      end

      it "calculates successfully with forbidden date ranges" do
        begindate = Date.parse("2050-01-01")  # this is a saturday
        skip_range = begindate..(begindate + 2.days)
        result = ChaptersPerDateCalculator.new(num_chapters: 5, begindate: begindate,
                                              date_ranges_to_skip: [skip_range]).find_available_days

        expect(result.size).to eq 5  # 5 unique days
        expect(result[begindate]).to be_nil

        # should be a hash entry for five days in a row starting three days (Tuesday) after begindate
        ((begindate + 3.days)..Date.parse("2050-01-08")).to_a.each do |a_date|
          expect(result[a_date]).to_not be_nil
        end
      end

    end
  end


end

