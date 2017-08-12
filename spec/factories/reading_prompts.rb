# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reading_prompt do
    reading
    content "MyText"
  end
end
