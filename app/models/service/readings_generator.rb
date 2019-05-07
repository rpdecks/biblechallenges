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
      query_fragment = chapters_for_this_day.map { |b, c| "(#{b}, #{c})" }.join(', ')
      chapters = Chapter.where("(book_id, chapter_number) IN (#{query_fragment})")

      chapters.each do |chap|
        readings << Reading.new(chapter: chap, read_on: date)
      end
    end

    Reading.transaction do
      readings.each do |r|
        Reading.connection.execute "INSERT INTO readings (chapter_id, challenge_id, read_on) values (#{r.chapter_id}, #{@challenge.id}, '#{r.read_on}')"
      end
    end
  end

  private

  def not_allowed_weekday?(a_date)
    @challenge.days_of_week_to_skip.include?(a_date.wday)
  end

  def not_allowed_date?(a_date)
    @challenge.date_ranges_to_skip.any? {|range| range.include?(a_date)}
  end

end
