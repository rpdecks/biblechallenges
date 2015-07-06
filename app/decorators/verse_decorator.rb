class VerseDecorator < Draper::Decorator
  delegate_all

  def to_div(verse_class: "verse", number_class: "verse_number")
    h.content_tag(:div, class: verse_class) do
      h.content_tag(:span, object.verse_number, class: number_class) +
      object.text
    end
  end

end
