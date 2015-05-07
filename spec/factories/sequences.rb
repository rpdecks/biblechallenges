FactoryGirl.define do
  sequence(:email) { |n| "#{rand(1000)}bc#{n}@test.com" }
end
