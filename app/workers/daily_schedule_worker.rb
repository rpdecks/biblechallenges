class DailyScheduleWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: true do
    daily.hour_of_day(23).minute_of_hour(0)
  end

  def perform
    DailyEmailScheduler.set_daily_email_jobs
  end
end