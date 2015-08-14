class NewChallengeEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: false

  def perform(challenge_id)
    ChallengeMailer.creation_email(challenge_id).deliver_now
  end

end
