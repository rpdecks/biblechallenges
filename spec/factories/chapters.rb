# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter do
    book_name "Genesis"
    sequence(:chapter_number) { |n| n }


  end
end
