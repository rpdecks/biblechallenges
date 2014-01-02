require 'securerandom'

if Rails.env.development?
  class MailPreview < MailView

    def daily_reading_email
      user = User.create(
        username:    Faker::Internet.user_name,
        first_name:   Faker::Name.first_name,
        last_name:    Faker::Name.last_name,
        email:        Faker::Internet.email,
        password: 'somepassword',
        password_confirmation: 'somepassword'
      )

      challenge = Challenge.create(subdomain: ('a'..'z').to_a.shuffle[0,8].join,
                                name: Faker::Company.name,
                                begindate: Time.now,
                                owner_id: 1, #to pass validations
                                chapters_to_read: "Matt 1-5")

      membership = Membership.create(challenge: challenge, user: user)
      membership_reading = membership.membership_readings.first
      MembershipReadingMailer.daily_reading_email(membership_reading)
    end
  end
end
