require 'faker'

FactoryGirl.define do
  factory :membership do    
    bible_version { %w(ASV ESV KJV NASB NKJV).sample }
    user {create(:user,:with_profile) }
    challenge

    trait :with_statistics do
      after(:create) { |object| object.associate_statistics }
    end

  end
end
