class ReadingsGenerator


  # days_of_week_to_skip is an array of days to skip reading.  For example, to skip weekends,
  # days_of_week_to_skip would be [0,6] because 0 is Sunday and 6 is Saturday

  # date_ranges_to_skip will have the following forms:
  # "2015-01-01..2015-01-07, 2015-02-01..2015-02-07" 

  def initialize(begindate, chapters_to_read, options={})
    @date = begindate
    @chapters_to_read = chapters_to_read
    @days_of_week_to_skip = options[:days_of_week_to_skip] || []
    @date_ranges_to_skip = options[:date_ranges_to_skip] || []
  end

  def generate
    date_ranges_to_skip = []
    readings = []
    read_on_date = @date

    if @date_ranges_to_skip.present?
      ranges = @date_ranges_to_skip.first.split(',')
      ranges.each do |r|
        beginning = r.split('..').first
        ending = r.split('..').last
        begin_date = Date.parse(beginning)
        end_date = Date.parse(ending)
        range = begin_date..end_date
        date_ranges_to_skip << range
      end
    end


    ActsAsScriptural.new.parse(@chapters_to_read).chapters.each do |chapter|
      # if the present day is not included in skippables, create a reading for it
      # Date.wday gives a number betw 0..6 for the day of week (0 is Sunday)
      if @date_ranges_to_skip.present?
        date_ranges_to_skip.each do |r|
          while @days_of_week_to_skip.include?(read_on_date.wday) || r.include?(read_on_date)
            read_on_date += 1.day
          end
        end
      else
        while @days_of_week_to_skip.include?(read_on_date.wday)
          read_on_date += 1.day
        end
      end

      unless @days_of_week_to_skip.include?(read_on_date.wday)
        chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
        readings << Reading.new(chapter: chapter, read_on: read_on_date)
      end

      read_on_date += 1.day

    end
    readings
  end




end
