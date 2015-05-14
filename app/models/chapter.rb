class Chapter < ActiveRecord::Base

  # Relations
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
  has_many :verses, primary_key: :chapter_index, foreign_key: :chapter_index  # needs to be ordered by verse_number #todo

  def book_and_chapter
    book_name + " " + chapter_number.to_s
  end



end
