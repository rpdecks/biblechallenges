
desc "Send daily email reading"
task daily_email: :environment do
  Membership.send_daily_emails
end
