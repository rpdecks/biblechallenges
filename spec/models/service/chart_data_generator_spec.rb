require 'spec_helper'

describe ChartDataGenerator do
  describe "benchmark_data" do
    it "returns an array of benchmark data" do
      challenge = create(:challenge, :with_readings)
      readings = challenge.readings
      membership_readings = double("membership_readings")
      benchmark_data = ChartDataGenerator.new(readings: readings, membership_readings: membership_readings).benchmark_data

      expect(benchmark_data.count).to eq readings.count + 1
    end
  end
end
