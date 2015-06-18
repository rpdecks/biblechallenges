# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                 {generate(:email)}
    password              "password"
    password_confirmation "password"

    trait :with_profile do
      profile
    end

    factory :user_with_profile, traits: [:with_profile]

  end

end
