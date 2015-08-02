class DailyEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: 3

  def perform(readings, member)
    ReadingMailer.daily_reading_email(readings, member).deliver_now
  end

end
