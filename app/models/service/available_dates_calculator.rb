class AvailableDatesCalculator

  # given a begindate, calculates an array of available dates where readings might be assigned

  attr_reader :available_dates

  def initialize(challenge)
    @challenge = challenge
    @num_chapters= challenge.book_chapters.size
  end

  def available_dates
    result = []
    read_on_date = @challenge.begindate
    chapters_left = @num_chapters

    while (chapters_left > 0) && before_end_date(read_on_date)

      while not_allowed_date?(read_on_date)
        read_on_date += 1.day
      end

      result << read_on_date
      chapters_left -= @challenge.num_chapters_per_day
      read_on_date += 1.day
    end

    set_enddate(result)
    result
  end
  private

  def set_enddate(result)
    unless @challenge.enddate || result.empty?
      @challenge.enddate = result.last unless @challenge.enddate
    end
  end

  def not_allowed_date?(a_date)
    not_allowed_weekday?(a_date) || within_forbidden_date_range?(a_date)
  end

  def not_allowed_weekday?(a_date)
    @challenge.days_of_week_to_skip.include?(a_date.wday)
  end

  def within_forbidden_date_range?(a_date)
    @challenge.date_ranges_to_skip.any? {|range| range.include?(a_date)}
  end

  def before_end_date(a_date)
    if @challenge.enddate && (a_date > @challenge.enddate)
      return false
    else
      return true
    end
  end
end

