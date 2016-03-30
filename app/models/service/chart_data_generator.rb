class ChartDataGenerator
  STARTING_DATA = ["start", 0]

  def initialize(readings:, membership_readings:)
    @readings = readings
    @membership_readings = membership_readings
  end

  def benchmark_data
    benchmark_initial_setup
    @readings.pluck(:read_on).uniq.each do |date|
      @benchmark_data_array << [
                          date.strftime("%-m/%-e"),
                          @readings.select { |x| x.read_on.to_date == date.to_date }.size +
                          @benchmark_data_array.last[-1]
                         ]
    end
    @benchmark_data_array
  end

  def member_reading_data
    member_readings_initial_setup
    @readings.pluck(:read_on).uniq.each do |r|
      @member_readings_data_array << [
                                      r.strftime("%-m/%-e"),
                                      (@membership_readings.
                                      select { |x| x.created_at.to_date == r.to_date }.size) + 
                                      @member_readings_data_array.last[-1]
                                     ]
    end
    @member_readings_data_array
  end

  def member_readings_initial_setup
    @member_readings_data_array = []
    @member_readings_data_array << STARTING_DATA
  end

  def benchmark_initial_setup
    @benchmark_data_array = []
    @benchmark_data_array << STARTING_DATA
    @chapters_per_day = 1
    @date_string_for_shovel = @readings.first.read_on.strftime("%-m/%-e")
  end
end
