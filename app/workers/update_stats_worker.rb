class UpdateStatsWorker
  include Sidekiq::Worker
  #if there is a problem with the email we don't want the worker retrying the job
  sidekiq_options :queue => :stats, :retry => false

  def perform(member_id)
    membership = Membership.find(member_id)
    user = membership.user
    user.update_stats
    membership.update_stats
    membership.group.update_stats if membership.group
    membership.challenge.update_stats
  end

end
