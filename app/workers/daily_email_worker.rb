class DailyEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: false

    def perform(user_reading_utc, reading, user)
        ReadingMailer.daily_reading_email(reading, m).deliver_now
    end
end
