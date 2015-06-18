require 'faker'

FactoryGirl.define do

  factory :challenge do
    name          { Faker::Commerce.product_name + " Challenge"}
    begindate     {Date.today}
    chapters_to_read { ["Matthew 1-2", "John 7-9", "Acts 5-8", "Romans 1-4"].sample }
    association :owner, factory: :user_with_profile

    trait :with_readings do
      after(:create) { |object| object.generate_readings }
    end

    factory :invalid_challenge do
      name nil
    end

    factory :challenge_with_readings, traits: [:with_readings]

  end
end
