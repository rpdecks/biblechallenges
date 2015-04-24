require 'faker'

FactoryGirl.define do


  factory :challenge do
    name          { Faker::Commerce.product_name + " Challenge"}
    begindate     {Date.tomorrow}
    chapters_to_read { ["Matthew 1-28", "John 1-21", "Acts 1-28", "Romans 1-16"].sample }
    welcome_message "Welcome to the Challenge!"
    association :owner, factory: :user

    factory :invalid_challenge do
      name nil
    end

  end
end
