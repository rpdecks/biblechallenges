include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    time_zone "UTC"
    preferred_reading_hour 6

    factory :user_with_avatar do
      avatar { fixture_file_upload(Rails.root.join('spec', 'images', 'my_avatar.png'),
                                   'image/png') }
    end

    factory :existing_facebook_user do
      provider "facebook"
      uid '12345'
      last_sign_in_at { Date.yesterday }
    end

    factory :existing_google_user do
      provider "google_oauth2"
      uid '54321'
      last_sign_in_at { Date.yesterday }
    end
  end
end
