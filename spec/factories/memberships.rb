require 'faker'

FactoryGirl.define do
  factory :membership do    
    bible_version { %w(ASV ESV KJV NASB NKJV).sample }
    user {create(:user,:with_profile) }
    challenge
  end
end
