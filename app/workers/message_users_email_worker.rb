class MessageUsersEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: 3

  def perform(email_array, message, challenge_id)
    challenge = Challenge.find(challenge_id)
    email_array.each do |email|
      MessageMailer.message_all_users_email(email, message, challenge).deliver_now
    end
  end

end
