class DailyEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: false

  def perform(readings, member_id)
    ReadingMailer.daily_reading_email(readings, member_id).deliver_now
  end
end
