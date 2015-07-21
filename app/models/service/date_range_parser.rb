class DateRangeParser

  def initialize(date_range_string)
    @date_range_string = date_range_string
  end

  def ranges
    [parse_string_range(@date_range_string)]
  end


  def parse_string_range(string_range)
    beginning = string_range.split('..').first
    ending = string_range.split('..').last
    begin_date = Date.parse(beginning)
    end_date = Date.parse(ending)
    begin_date..end_date
  end
end

