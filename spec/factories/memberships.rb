require 'faker'

FactoryGirl.define do
  factory :membership do
    user {create(:user) }
    challenge

    trait :with_statistics do
      after(:create) { |object| object.associate_statistics }
    end
  end
end
