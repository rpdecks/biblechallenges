require 'faker'

FactoryGirl.define do


  factory :challenge do
    name          {Faker::Name.name}
    begindate     {Date.tomorrow}
    chapters_to_read "Matthew 1 -5"
    welcome_message "Welcome to the Challenge!"
    association :owner, factory: :user

    factory :invalid_challenge do
      name nil
    end

  end
end
