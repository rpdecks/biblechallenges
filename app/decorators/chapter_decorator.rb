class ChapterDecorator < Draper::Decorator
  delegate_all

  def by_version(version = "ASV")
    chapter_heading +
    verses_by_version(version)
  end

  private

  def chapter_heading
    "<strong>#{book_name} #{chapter_number}</strong></br>"
  end

  def book_name
    object.book_name
  end

  def chapter_number
    object.chapter_number
  end

  def verses_by_version(version, start_verse: nil, end_verse: nil)
    ordered_verses = object.verses.order(:verse_number).by_version(version).decorate
    ordered_verses.map {|verse| verse.to_div}.join
  end

#  verse_range should go on the model

end
