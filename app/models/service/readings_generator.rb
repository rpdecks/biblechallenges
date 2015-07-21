class ReadingsGenerator


  # days_of_week_to_skip is an array of days to skip reading.  For example, to skip weekends,
  # days_of_week_to_skip would be [0,6] because 0 is Sunday and 6 is Saturday

  # date_ranges_to_skip will have the following forms:
  # "2015-01-01..2015-01-07, 2015-02-01..2015-02-07" 

  def initialize(begindate, chapters_to_read, options={})
    @date = begindate
    @chapters_to_read = chapters_to_read
    @days_of_week_to_skip = options[:days_of_week_to_skip] || []
    @dates_to_skip = options[:dates_to_skip] || []
  end

  def generate
    readings = []
    read_on_date = @date

    ActsAsScriptural.new.parse(@chapters_to_read).chapters.each do |chapter|
      # if the present day is not included in skippables, create a reading for it
      # Date.wday gives a number betw 0..6 for the day of week (0 is Sunday)

      while (not_allowed_weekday?(read_on_date) || not_allowed_date?(read_on_date))
        read_on_date += 1.day
      end

      unless @days_of_week_to_skip.include?(read_on_date.wday)
        chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
        readings << Reading.new(chapter: chapter, read_on: read_on_date)
      end

      read_on_date += 1.day

    end
    readings
  end

  private

  def not_allowed_weekday?(a_date)
    @days_of_week_to_skip.include?(a_date.wday)
  end

  def not_allowed_date?(a_date)
    date_ranges_to_skip.any? {|range| range.include?(a_date)}
  end

  def date_ranges_to_skip
    ranges_to_skip = []
    if @dates_to_skip.present?
      ranges_from_string.each do |range|
        ranges_to_skip << parse_string_range(range)
      end
    end
    ranges_to_skip
  end

  def ranges_from_string
    @dates_to_skip.split(',')
  end

  def parse_string_range(string_range)
#    "2020-01-01..2020-01-05"
    beginning = string_range.split('..').first
    ending = string_range.split('..').last
    begin_date = Date.parse(beginning)
    end_date = Date.parse(ending)
    begin_date..end_date
  end


end
