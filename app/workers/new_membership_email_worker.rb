class NewMembershipEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: false

  def perform(membership_id)
    MembershipMailer.creation_email(membership_id).deliver_now
  end

end
