require 'faker'

FactoryGirl.define do
  factory :membership do
    username    {Faker::Internet.user_name}
    firstname   {Faker::Name.first_name}
    lastname    {Faker::Name.last_name}
    email       {Faker::Internet.email}
    user
    challenge
  end
end
