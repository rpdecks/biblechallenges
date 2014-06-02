require 'faker'

FactoryGirl.define do

  sequence(:subdomain) { |n| "testsubdomain#{n}" }

  factory :challenge do
    subdomain     {generate(:subdomain)}
    name          {Faker::Name.name}
    begindate     {Date.tomorrow}
    chapters_to_read "Matthew 1 -5"
    welcome_message "Welcome to the Challenge!"
    association :owner, factory: :user

    factory :invalid_challenge do
      subdomain nil
    end

  end
end
