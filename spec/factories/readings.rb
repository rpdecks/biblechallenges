# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reading do
    challenge
    chapter
    date      {Date.today}
    discussion "This is so interesting"
  end
end
