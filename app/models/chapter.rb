class Chapter < ActiveRecord::Base

  # Relations
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
  has_many :verses, primary_key: :chapter_index, foreign_key: :chapter_index  # needs to be ordered by verse_number #todo

  def book_and_chapter
    book_name + " " + chapter_number.to_s
  end


  def verses_by_range(start_verse: nil, end_verse: nil)
    if start_verse && end_verse
      verses.where(verse_number: [start_verse..end_verse]).order(:verse_number)
    elsif start_verse
      verses.where("verse_number >= ?", start_verse).order(:verse_number)
    elsif end_verse
      verses.where("verse_number <= ?", end_verse).order(:verse_number)
    else 
      verses.order(:verse_number)
    end
  end


end
