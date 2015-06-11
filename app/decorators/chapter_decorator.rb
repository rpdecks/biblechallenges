class ChapterDecorator < Draper::Decorator
  delegate_all

  def by_version(version = "ASV")
    chapter_heading +
    verses_by_version(version)
  end

  private

  def chapter_heading
    "<strong>#{book_name} #{chapter_number}</strong> \n"
  end

  def book_name
    object.book_name
  end

  def chapter_number
    object.chapter_number
  end

  def verses_by_version(version)
    ordered_verses = object.verses.by_version(version).sort_by { |verse| verse.verse_number }
    ordered_verses.map {|verse| "#{verse.verse_number} #{verse.versetext}" }.join("\n")
  end
end
