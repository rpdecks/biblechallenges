require 'faker'

FactoryGirl.define do

  sequence(:subdomain) { |n| "testsubdomain#{n}" }
  factory :challenge do
    subdomain     {generate(:subdomain)}
    name          {Faker::Name.name}
    begindate     {Time.now}
    enddate       {Time.now + 1.day}
    chapterstoread "Matthew 1 to Matthew 5"
    association :owner, factory: :user
  end
end
