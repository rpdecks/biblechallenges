class ChapterDecorator < Draper::Decorator
  delegate_all

  def by_version(version = "ASV")
    chapter_heading + 
    verses_by_version(version)
  end

  private

  def chapter_heading
    "#{book_name} #{chapter_number}"
  end

  def book_name
    object.book_name
  end

  def chapter_number
    object.chapter_number
  end

  def verses_by_version(version)
    object.verses.by_version(version).map {|verse| "#{verse.verse_number} #{verse.versetext}" }.join("\n")
  end


end
