class Chapter < ActiveRecord::Base

  # Relations
  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges
  has_many :verses, primary_key: :chapter_index, foreign_key: :chapter_index  # needs to be ordered by verse_number #todo
  has_many :membership_readings

  def book_and_chapter
    @book_and_chapter ||= book_name + ' ' + chapter_number.to_s
  end

  def self.book_name_from_pair(book_chapter_pair)
    ActsAsScriptural::Bible.new.book_names[book_chapter_pair.first-1]
  end

  def self.book_and_chapter_from_pair(book_chapter_pair)
    ActsAsScriptural::Bible.new.book_names[book_chapter_pair.first-1] + " " + book_chapter_pair.last.to_s
  end

  def by_version(version = Verse::DEFAULT_VERSION)
    # no rcv verses exist
    # weird version
    # good version
    # rcv with existing verses
    # good version with no verses
    if version == "RCV"
      RetrieveRcv.new(self).refresh
    end

    response = verses.where(version: version)

    if response.empty?
      response = by_version(Verse::DEFAULT_VERSION)
    end

    response
  end

  private

  def user_bible_version_not_valid?(version)
    !User::BIBLE_VERSIONS.include?(version)
  end
end
