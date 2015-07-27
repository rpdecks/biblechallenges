class DateRangeParser

  attr_accessor :error

  def initialize(date_ranges_string)
    @date_ranges_string = date_ranges_string
  end

  def ranges
    if @date_ranges_string.nil?
      return []
    else
      range_strings = @date_ranges_string.split(',')
      parse_range_strings(range_strings)
    end
  end

  private

  def parse_range_strings(range_strings)
    range_strings.map{|rs| parse_a_range_string(rs)}.compact  # kill those nils
  end

  def parse_a_range_string(string_range)
    beginning = string_range.split('..').first
    ending = string_range.split('..').last
    begin
      begin_date = Date.parse(beginning)
      end_date = Date.parse(ending)
      begin_date..end_date
    rescue ArgumentError
      @error = "Error with date range"
      nil
    end
  end
end

