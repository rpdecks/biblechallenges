# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :verse do
    version "MyString"
    book_name "MyString"
    chapter_number 1
    verse_number 1
    versetext "MyText"
    book_id 1
  end
end
