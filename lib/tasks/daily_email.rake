
desc "Send daily email reading"
task daily_email: :environment do

  DailyEmailScheduler.set_daily_email_job

end
