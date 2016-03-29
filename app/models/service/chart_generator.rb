class ChartDataGenerator
  def initialize(readings:, membership_readings:)
    @readings = readings
    @membership_readings = membership_readings
  end

  def whole_challenge_benchmark_data
    benchmark_data = [["start", 0]]
    readings_per_day_count = 1
    yesterdays_reading_date_string = @readings.first.read_on.strftime("%-m/%-e")
    @readings.each do |r|
      reading_date_string = r.read_on.strftime("%-m/%-e")
      if reading_date_string == yesterdays_reading_date_string
        if r != @readings.first
          readings_per_day_count += 1
          yesterdays_reading_date_string = reading_date_string
        end
        if r == @readings.last
          benchmark_data << [yesterdays_reading_date_string, benchmark_data.last[-1] + readings_per_day_count]
        end
        next
      else
        benchmark_data << [yesterdays_reading_date_string, benchmark_data.last[-1] + readings_per_day_count]
        yesterdays_reading_date_string = reading_date_string
        readings_per_day_count = 1
      end
    end
    benchmark_data
  end

  def whole_challenge_mrs
    membership_readings_data = [["start", 0]]
    @readings.pluck(:read_on).uniq.each do |r|
      membership_readings_data << [r.strftime("%-m/%-e"), (@membership_readings.select { |x| x.created_at.to_date == r.to_date }.size) + membership_readings_data.last[-1]]
    end

    membership_readings_data
  end

  def recent_mrs
  end

  def recent_benchmark_data
  end

end
