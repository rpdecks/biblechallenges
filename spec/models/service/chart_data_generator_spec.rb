require 'spec_helper'

describe ChartDataGenerator do
  describe "benchmark_data" do
    it "returns an array of benchmark data" do
      challenge = create(:challenge, :with_readings)
      readings = challenge.readings
      membership_readings = double("membership_readings")
      benchmark_data = ChartDataGenerator.new(readings: readings, membership_readings: membership_readings).benchmark_data

      expect(benchmark_data.first).to eq ["start", 0]
      expect(benchmark_data.count).to eq (readings.count + 1)
    end
  end
  describe "member_reading_data" do
    it "returns an array of membership readings data" do
      challenge = create(:challenge, :with_readings)
      membership = create(:membership, challenge: challenge)
      readings = challenge.readings
      create(:membership_reading, membership: membership)
      create(:membership_reading, membership: membership)
      mrs = membership.membership_readings

      member_reading_data = ChartDataGenerator.new(readings: readings,
                                           membership_readings: mrs).member_reading_data

      expect(member_reading_data.count).to eq 3
      expect(member_reading_data.last[-1]).to eq 2
      expect(member_reading_data.first).to eq ["start", 0]
    end
  end
end
