require 'faker'

FactoryGirl.define do
  factory :challenge do
    subdomain     {Faker::Internet.domain_name}
    name          {Faker::Name.name}
    begindate     {Time.now}
    enddate       {Time.now + 1.day}
    chapterstoread "Matthew 1 to Matthew 5"
    association :owner, factory: :user
  end
end
