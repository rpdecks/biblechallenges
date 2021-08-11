namespace :daily_email_scheduler do
  desc "Schedules daily reading emails"

  task invoke: :environment do
    DailyEmailScheduler.set_daily_email_jobs
  end
end  
