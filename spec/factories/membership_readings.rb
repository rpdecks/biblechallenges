# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership_reading do
    membership
    reading
    user
    chapter
  end
end
