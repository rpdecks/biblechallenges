
desc "Send daily email reading"
task daily_email: :environment do
  #start time is zero hundred hours in Moscow; this covers accurately everyting thru Hawaii
  if Time.now.utc.strftime("%H") == 20
    DailyEmailScheduler.set_daily_email_job
  end
end
