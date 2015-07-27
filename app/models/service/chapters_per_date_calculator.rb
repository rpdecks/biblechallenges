class ChaptersPerDateCalculator

  # should produce a hash with dates as keys and numbers of chapters for those dates as values

  # required options passed in are begindate, num_chapters
  # optional are enddate, num_chapters_per_day, date_ranges_to_skip, and days_of_week_to_skip

  attr_reader :schedule

  def initialize(begindate:, num_chapters:, num_chapters_per_day: 1,
                days_of_week_to_skip: [],
                date_ranges_to_skip: [])

    @begindate = begindate
    @num_chapters= num_chapters
    @num_chapters_per_day = num_chapters_per_day
    @days_of_week_to_skip = days_of_week_to_skip
    @date_ranges_to_skip = date_ranges_to_skip
  end

  def available_days
    result = []
    read_on_date = @begindate
    chapters_left = @num_chapters

    while (chapters_left > 0)

      while not_allowed_date?(read_on_date)
        read_on_date += 1.day
      end

      result << read_on_date
      chapters_left -= @num_chapters_per_day
      read_on_date += 1.day
    end

    result
  end

  private

  def not_allowed_date?(a_date)
    not_allowed_weekday?(a_date) || within_forbidden_date_range?(a_date)
  end

  def not_allowed_weekday?(a_date)
    @days_of_week_to_skip.include?(a_date.wday)
  end

  def within_forbidden_date_range?(a_date)
    @date_ranges_to_skip.any? {|range| range.include?(a_date)}
  end



end


