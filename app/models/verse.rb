class Verse < ActiveRecord::Base
  attr_accessible :book_id, :book_name, :chapter_number, :verse_number, :versetext, :version
end
