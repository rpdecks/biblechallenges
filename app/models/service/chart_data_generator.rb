class ChartDataGenerator
  def initialize(readings:, membership_readings:)
    @readings = readings
    @membership_readings = membership_readings
  end

  def benchmark_data
    initial_setup
    @readings.pluck(:read_on).uniq.each do |date|
      @benchmark_data << [
                          date.strftime("%-m/%-e"),
                          @readings.select { |x| x.read_on.to_date == date.to_date }.size +
                          @benchmark_data.last[-1]
                         ]
    end
    @benchmark_data
  end

  def whole_challenge_membership_reading_data
    membership_readings_data = [["start", 0]]
    @readings.pluck(:read_on).uniq.each do |r|
      membership_readings_data << [r.strftime("%-m/%-e"), (@membership_readings.select { |x| x.created_at.to_date == r.to_date }.size) + membership_readings_data.last[-1]]
    end

    membership_readings_data
  end

  def initial_setup
    @benchmark_data = [["start", 0]]
    @chapters_per_day = 1
    @date_string_for_shovel = @readings.first.read_on.strftime("%-m/%-e")
  end
end
