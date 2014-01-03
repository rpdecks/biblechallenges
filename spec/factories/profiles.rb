# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    username    {Faker::Internet.user_name}
    first_name   {Faker::Name.first_name}
    last_name    {Faker::Name.last_name}
  end
end
