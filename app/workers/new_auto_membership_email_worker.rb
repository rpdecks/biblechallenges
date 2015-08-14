class NewAutoMembershipEmailWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options retry: false

  def perform(membership_id, password)
    MembershipMailer.auto_creation_email(membership_id, password).deliver_now
  end

end
