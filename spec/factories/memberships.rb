# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    username "joe"
    firstname "Joe"
    lastname "Smith"
    email "joe@example.com"
    user_id 1
    challenge_id 1
  end
end
