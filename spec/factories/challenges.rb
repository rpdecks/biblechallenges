require 'faker'

FactoryGirl.define do

  sequence(:subdomain) { |n| "testsubdomain#{n}" }
  
  factory :challenge do
    subdomain     {generate(:subdomain)}
    name          {Faker::Name.name}
    begindate     {Date.today}
    chapterstoread "Matthew 1 -5"
    association :owner, factory: :user

    factory :invalid_challenge do
      subdomain nil
    end

  end
end
