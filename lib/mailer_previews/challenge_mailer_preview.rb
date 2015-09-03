class ChallengeMailerPreview < ActionMailer::Preview

  def snapshot_email
    other = Challenge.last
    ChallengeMailer.snapshot_email(Challenge.third)
  end
end

