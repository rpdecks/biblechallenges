
desc "Send daily email reading"
task daily_email: :environment do
  #using sidekiq set the time for the emails to be prepared
  #Prague 4 am Monday is US Eastern 22 Sunday
  if Time.now.strftime("%H") == 0
    Membership.set_daily_email_job
  end
end
