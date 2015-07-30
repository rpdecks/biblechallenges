class ReadingsGenerator


  def initialize(challenge)
    @challenge = challenge
  end

  def generate
    schedule = ChaptersPerDateCalculator.new(@challenge).schedule

    readings = []
    chapters_to_read = @challenge.book_chapters
    # go thru the hash in chrono order
    schedule.keys.sort.each do |date|
      num_chapters = schedule[date]
      chapters_for_this_day = chapters_to_read.shift(num_chapters)

      chapters_for_this_day.each do |chapter|
        chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
        readings << Reading.new(chapter: chapter, read_on: date)
      end
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
