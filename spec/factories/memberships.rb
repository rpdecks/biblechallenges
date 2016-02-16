require 'faker'

FactoryGirl.define do
  factory :membership do    
    bible_version { %w(RCV ASV ESV KJV NASB NKJV).sample }
    user {create(:user) }
    challenge

    trait :with_statistics do
      after(:create) { |object| object.associate_statistics }
    end

  end
end
