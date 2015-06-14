class Verse < Draper::Decorator
  delegate_all

  def to_divvv(verse_class: nil, number_class: nil)
    content_tag(:div, object.versetext) do
      content_tag(:span, object.verse_number) 
    end
  end

end
