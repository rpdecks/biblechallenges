class ChaptersPerDateCalculator

  # should produce a hash with dates as keys and numbers of chapters for those dates as values

  # required options passed in are begindate, num_chapters
  # optional are enddate, num_chapters_per_day, date_ranges_to_skip, and days_of_week_to_skip

  attr_reader :schedule

  def initialize(challenge)
    @challenge = challenge
    @num_chapters = challenge.book_chapters.size
  end

  def available_dates
    @available_dates ||= AvailableDatesCalculator.new(@challenge).available_dates
  end

  def chapter_distribution
    @chapter_distribution ||= ChapterDistributionCalculator.new( num_days: available_dates.size, 
                                                                num_chapters: @num_chapters).distribution
  end

  def schedule
    dates = available_dates
    chapters = chapter_distribution
    result = {}
    while (date = dates.pop) && (chapters_that_day = chapters.pop)
      result[date] = chapters_that_day
    end
    result
  end

end


