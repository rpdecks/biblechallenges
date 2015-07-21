class ReadingsGenerator


  def initialize(challenge)
    @challenge = challenge
  end

  def generate
    readings = []
    read_on_date = @challenge.begindate

    @challenge.book_chapters.each do |chapter|
      # if the present day is not included in skippables, create a reading for it
      # Date.wday gives a number betw 0..6 for the day of week (0 is Sunday)

      while (not_allowed_weekday?(read_on_date) || not_allowed_date?(read_on_date))
        read_on_date += 1.day
      end

      unless @challenge.days_of_week_to_skip.include?(read_on_date.wday)
        chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
        readings << Reading.new(chapter: chapter, read_on: read_on_date)
      end

      read_on_date += 1.day

    end
    readings
  end

  private

  def not_allowed_weekday?(a_date)
    @challenge.days_of_week_to_skip.include?(a_date.wday)
  end

  def not_allowed_date?(a_date)
    @challenge.date_ranges_to_skip.any? {|range| range.include?(a_date)}
  end

end
