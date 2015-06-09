class ReadingsGenerator


  def initialize(begindate, chapters_to_read)
    @begindate = begindate
    @chapters_to_read = chapters_to_read
  end

  def generate
    readings = []
    read_on = @begindate

    ActsAsScriptural.new.parse(@chapters_to_read).chapters.each do |chapter|
      chapter = Chapter.find_by_book_id_and_chapter_number(chapter.first, chapter.last)
      readings << Reading.new(chapter: chapter, read_on: read_on)
      read_on += 1.day
    end


    readings
  end

end
