class Verse < ActiveRecord::Base

  Verse::DEFAULT_VERSION = "ASV"

  # Relations
  belongs_to :chapter, foreign_key: :chapter_index

  default_scope { order(:verse_number) }

  def self.by_version(version)
    response = where(version: version)
    response.any? ? response : where(version: DEFAULT_VERSION)
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
end
