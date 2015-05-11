# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:challenge_id) { |n| n }
    sequence(:name, 50) { |n| "Group name #{n}" }
    user_id 1
  end
end
