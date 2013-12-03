# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership_form do
    bible_version   { %w(ASV ESV KJV NASB NKJV).sample }
    email           {generate(:email)}
  end
end
