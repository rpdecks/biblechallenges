# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email
    password "password"
    password_confirmation "password"
  end

  sequence :email do |n|
    "joe#{n}@example.com"
  end
end
