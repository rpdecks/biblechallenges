class SnapshotEmailWorker
  include Sidekiq::Worker

  def perform(recipient, challenge_id)
    challenge = Challenge.find(challenge_id)
    ChallengeMailer.snapshot_email(recipient, ChallengeSnapshot.new(challenge)).deliver_now
  end
end

