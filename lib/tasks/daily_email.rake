require 'rake_performance'

desc "Send daily email reading"
task daily_email: :environment do
  MembershipReading.send_daily_emails
end
