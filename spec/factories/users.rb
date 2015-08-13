FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    time_zone "UTC"
    preferred_reading_hour 6

    factory :facebook_user do
      provider "facebook"
      uid '12345'
    end
  end
end
