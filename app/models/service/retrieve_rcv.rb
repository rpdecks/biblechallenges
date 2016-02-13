class RetrieveRcv
  def initialize(book_name:, chapter_number:, chapter_index:, book_id:)
    @book_name = book_name
    @chapter_number = chapter_number
    @chapter_index = chapter_index
    @book_id = book_id
    @verses = RcvBible::Reference.new(book_and_chapter).verses
  end

  def park_rcv_chapter
    @verses.each.with_index(1) do |v, index|
      verse = Verse.new(version: "RCV", book_name: @book_name, chapter_number: @chapter_number, verse_number: index, versetext: v["text"], book_id: @book_id, chapter_index: @chapter_index)
      if verse.versetext
        verse.save
      end
    end
  end

  def retouch_rcv_chapter
    @verses.each.with_index(1) do |v, index|
      verse = Verse.where(chapter_index: @chapter_index).find_by_verse_number(index)
      verse.touch unless verse.nil?
    end
  end

  def book_and_chapter
    @book_name + " " + @chapter_number.to_s
  end

end
