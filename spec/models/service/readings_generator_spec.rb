require 'spec_helper'

describe ReadingsGenerator do

  describe '#generate' do
    describe "Generates the correct number of readings" do
      it "Generates 5 readings when given Matt 1-5" do
        challenge = FactoryGirl.create(:challenge, chapters_to_read: "Matthew 1-5")

        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.size).to eq 5
      end
      it "Generates 4 readings when given Gen1, Luke1-2, Rev 3" do
        challenge = FactoryGirl.create(:challenge, chapters_to_read: "Gen 1, Luke1-2, Rev 3")

        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.size).to eq 4
      end
    end

    describe "Generates readings on the correct days" do
      it "Generates the first reading on begindate" do
        challenge = FactoryGirl.create(:challenge, begindate: Date.today)

        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.first.read_on).to eq Date.today
      end

      it "Generates the last reading on the correct day" do
        begindate = Date.parse "2050-01-01"
        challenge = FactoryGirl.create(:challenge, chapters_to_read: "Matt 1-3", begindate: begindate)

        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.last.read_on).to eq Date.parse("2050-01-03")
      end
    end


    describe "Skips days of the week correctly" do
      it "skips the first day of the challenge when the challenge starts on a skip day" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday
        challenge = FactoryGirl.create(:challenge, 
                                       chapters_to_read: "Matt 1-3", 
                                       begindate: begindate,
                                      days_of_week_to_skip: [6])

        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.first.read_on).to eq Date.parse("2050-01-02")
        expect(readings.size).to eq 3
      end
      it "Schedules only on Mondays when we exclude the other days" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday
        challenge = FactoryGirl.create(:challenge, begindate: begindate, 
                                       chapters_to_read: "Matthew 1-5", 
                                       days_of_week_to_skip: [0,2,3,4,5,6])
        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.size).to eq 5
        readings.each do |r|
          expect(r.read_on.wday).to eq 1
        end
      end

      it "does not create readings for selected date ranges" do
        begindate = Date.parse "2050-01-01"  # this is a Saturday
        challenge = FactoryGirl.create(:challenge, begindate: begindate, 
                                       chapters_to_read: "Matthew 1-5", 
                                       dates_to_skip: "2050-01-02..2050-01-07")
        readings = ReadingsGenerator.new(challenge).generate

        expect(readings.last.read_on).to eq Date.parse("2050-01-11")
        expect(readings.size).to eq 5
      end

      it "does not create readings for selected skip date ranges and days of week" do
        begindate = Date.parse "2050-01-14"  # this is a Friday
        challenge = FactoryGirl.create(:challenge, begindate: begindate, chapters_to_read: "Mat 1-5",
                                       days_of_week_to_skip: [6,0], dates_to_skip: "2050-01-17..2050-01-20")
        readings = ReadingsGenerator.new(challenge).generate  # skipping weekends(Sat-Sun) & next Mon-Thu(date-range)

        expect(readings.first.read_on).to eq Date.parse("2050-01-14")
        expect(readings.second.read_on).to eq Date.parse("2050-01-21")
        expect(readings.size).to eq 5
      end
    end
  end
end

