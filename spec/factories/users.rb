# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                 {generate(:email)} #todo: refactor this using faker
    password              "password"
    password_confirmation "password"
    username    {Faker::Internet.user_name}
    time_zone "UTC"
    preferred_reading_hour 6
  end
end
