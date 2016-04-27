class ReadingDecorator < Draper::Decorator
  delegate_all

  def todays_chapter(membership)
    reading.chapter.by_version(membership.user.bible_version).each do |v|
      v.text
    end
  end

end
