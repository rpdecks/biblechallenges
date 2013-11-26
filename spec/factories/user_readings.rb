# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_reading do
    user
    reading
  end
end
