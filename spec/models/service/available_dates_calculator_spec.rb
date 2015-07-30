require 'spec_helper'

describe AvailableDatesCalculator do
  let(:challenge) { build(:challenge, chapters_to_read: "Matt 1-5",
                           begindate: Date.parse("2050-01-01"))
  }
  let(:sat_sunday)  {[6,0]}

  context "with no enddate set" do
    it "calculates correctly with one chap per day" do
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 5
      (challenge.begindate..(challenge.begindate + 4.days)).to_a.each do |a_date|
        expect(result).to include a_date
      end
    end
    it "calculates with two chapters per day" do
      challenge.num_chapters_per_day = 2
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 3  # 5 chapters at 2 chapters per day
      (challenge.begindate..(challenge.begindate + 2.days)).to_a.each do |a_date|
        expect(result).to include a_date
      end
    end
    it "handles days_of_week_to_skip" do
      #begindate is a Saturday
      challenge.days_of_week_to_skip = sat_sunday
      challenge.valid?  #force callbacks

      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 5  # five total chapters in the challenge
      expect(result).to_not include challenge.begindate
      # should be a hash entry for five days in a row starting two days (monday) after begindate
      ((challenge.begindate + 2.days)..(challenge.begindate + 6.days)).to_a.each do |a_date|
        expect(result).to include a_date
      end
    end
    it "calculates successfully with forbidden date ranges" do
      challenge =  build(:challenge, chapters_to_read: "Matt 1-5",
                         begindate: Date.parse("2050-01-01"),
                        dates_to_skip: "2050-01-01..2050-01-03")
      challenge.generate_book_chapters
      challenge.generate_date_ranges_to_skip
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 5  # 5 unique days
      expect(result).to_not include challenge.begindate

      # should be a hash entry for five days in a row starting three days (Tuesday) after begindate
      ((challenge.begindate + 3.days)..(challenge.begindate + 7.days)).to_a.each do |a_date|
        expect(result).to include a_date 
      end
    end
  end

  context "with an enddate set" do

    it "calculates correctly with one chap per day" do
      challenge.enddate = challenge.begindate + 3.days
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 4
      (challenge.begindate..(challenge.begindate + 3.days)).to_a.each do |a_date|
        expect(result).to include a_date
      end
    end
    it "calculates with two chapters per day" do
      challenge.num_chapters_per_day = 2
      challenge.enddate = challenge.begindate + 2.days
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 3  # 5 chapters at 2 chapters per day
      (challenge.begindate..(challenge.begindate + 2.days)).to_a.each do |a_date|
        expect(result).to include a_date
      end
    end
    it "handles days_of_week_to_skip" do
      #begindate is a Saturday
      challenge.enddate = challenge.begindate + 2.days
      challenge.days_of_week_to_skip = sat_sunday
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      # should only be one record in the result since sat and sun are skipped
      expect(result.size).to eq 1
      expect(result).to_not include challenge.begindate
      expect(result.first).to eq (challenge.begindate + 2.days)

    end
    it "calculates successfully with forbidden date ranges" do
      challenge.enddate = Date.parse("2050-01-05")
      challenge.dates_to_skip = "2050-01-01..2050-01-03"
      challenge.valid?  #force callbacks
      result = AvailableDatesCalculator.new(challenge).available_dates

      expect(result.size).to eq 2 
      expect(result).to_not include challenge.begindate

      ((challenge.begindate + 3.days)..(challenge.begindate + 4.days)).to_a.each do |a_date|
        expect(result).to include a_date 
      end
    end
  end



end


