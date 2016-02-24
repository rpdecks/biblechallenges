class Chapter < ActiveRecord::Base

  # Relations
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
  has_many :verses, primary_key: :chapter_index, foreign_key: :chapter_index  # needs to be ordered by verse_number #todo
  has_many :membership_readings

  def book_and_chapter
    book_name + " " + chapter_number.to_s
  end

  def self.book_name_from_pair(book_chapter_pair)
    ActsAsScriptural::Bible.new.book_names[book_chapter_pair.first-1]
  end

  def self.book_and_chapter_from_pair(book_chapter_pair)
    ActsAsScriptural::Bible.new.book_names[book_chapter_pair.first-1] + " " + book_chapter_pair.last.to_s
  end

  def by_version(version = Verse::DEFAULT_VERSION)
    version = Verse::DEFAULT_VERSION if !User::BIBLE_VERSIONS.include?(version)
    RetrieveRcv.new(self).refresh if version == 'RCV'
    version = Verse::DEFAULT_VERSION if version_missing?(version)

    verses.where(version: version)
  end

  private

  def version_missing?(version)
    verses.where(version: version).empty?
  end

end
