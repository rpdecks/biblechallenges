class DailyEmailWorker
  include Sidekiq::Worker
    def perform(user_reading_utc, reading, user)
        ReadingMailer.daily_reading_email(reading, m).deliver_now
    end
end
