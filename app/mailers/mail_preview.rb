if Rails.env.development?
  class MailPreview < MailView

    def daily_reading_email
      challenge = Challenge.first
      membership_reading = challenge.memberships.first.membership_readings.first
      MembershipReadingMailer.daily_reading_email(membership_reading)
    end

  end
end
