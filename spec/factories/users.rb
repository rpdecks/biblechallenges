# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| "bc#{n}@test.com" }
  factory :user do
    email                 {generate(:email)}
    password              "password"
    password_confirmation "password"
  end

end
