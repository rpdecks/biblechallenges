require 'spec_helper'

describe ChaptersPerDateCalculator do

  # should produce a hash with dates as keys and numbers of chapters for those dates as values

  # required options passed in are begindate, num_chapters
  # optional are enddate, num_chapters_per_day, dates_to_skip, and days_of_week_to_skip

  describe "With one chapter a day" do
    it "calculates successfully with no special options" do
      begindate = Date.parse("2050-01-01")
      result = ChaptersPerDateCalculator.new(num_chapters: 5, begindate: begindate)
      binding.pry

      expect(result.schedule.size).to eq 5


    


    end
  end


end

