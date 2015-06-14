class Verse < ActiveRecord::Base

  # Relations
  belongs_to :chapter, foreign_key: :chapter_index

  default_scope { order(:verse_number) }

  def self.by_version(version)
    #if the chosen version is not in the verses table, go with ASV
    #this default version should probably be in a constant  (ASV)
    response = where(version: version)
    response.any? ? response : where(version: "ASV")
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
