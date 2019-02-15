# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reading do
    challenge
    chapter
    read_on      {Date.today}
    discussion "This is so interesting"

    trait :with_challenge_membership do
      association :challenge, :with_membership
    end
  end
end
