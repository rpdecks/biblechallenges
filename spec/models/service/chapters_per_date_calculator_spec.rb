require 'spec_helper'

describe ChaptersPerDateCalculator do
  let!(:begindate) {Date.parse("2050-01-01")}

  it "calculates properly for the new testament in one month (260 chapters)" do
    date_range = (Date.parse("2050-01-01"))..(Date.parse("2050-01-30"))
    challenge = create(:challenge,
                       chapters_to_read: "Matt 1-Rev 22",
                       begindate: begindate,
                      enddate: Date.parse("2050-01-30")
                      )

    result = ChaptersPerDateCalculator.new(challenge).schedule

    expect(result.size).to eq 30
    expect(result.values.sum).to eq 260

    # every date should have a value
    date_range.to_a.each do |a_date|
      expect(result[a_date]).to_not be_nil
    end
  end
end

