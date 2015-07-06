FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    username { Faker::Internet.user_name }
    time_zone "UTC"
    preferred_reading_hour 6
  end
end
