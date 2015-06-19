# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                 {generate(:email)}
    password              "password"
    password_confirmation "password"
    profile
  end
end
