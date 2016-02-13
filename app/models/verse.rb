class Verse < ActiveRecord::Base
  require 'htmlentities'
  Verse::DEFAULT_VERSION = "ASV"

  belongs_to :chapter, foreign_key: :chapter_index

  default_scope { order(:verse_number) }

  def self.by_version(version)
    response = where(version: version)
    if response.any?
      if version == 'RCV'
        if response.first.updated_at < 10.days.ago
          RetrieveRcv.new(chapter_number: self.first.chapter_number, book_name: self.first.book_name, book_id: self.first.book_id, chapter_index: self.first.chapter_index).retouch_rcv_chapter
        end
      end
      response
    elsif version == "RCV"
      bookname = self.first.book_name
      chapternumber = self.first.chapter_number
      bookid = self.first.book_id
      chapterindex = self.first.chapter_index
      RetrieveRcv.new(chapter_number: chapternumber, book_name: bookname, book_id: bookid, chapter_index: chapterindex).park_rcv_chapter
    else
      # some error?
    end
  end

  def self.by_range(start_verse: nil, end_verse: nil)
    if start_verse && end_verse
      where(verse_number: [start_verse..end_verse])
    elsif start_verse
      where("verse_number >= ?", start_verse)
    elsif end_verse
      where("verse_number <= ?", end_verse)
    else 
      all
    end
  end

  def text
    coder = HTMLEntities.new
    coder.decode(self.versetext)
  end

  def book_and_chapter
    @book_name + " " + @chapter_number.to_s
  end
end
