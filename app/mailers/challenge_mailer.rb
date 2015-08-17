class ChallengeMailer < ActionMailer::Base

  helper ActionView::Helpers::UrlHelper

  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  # Send an email to the user, when the Challenge creation is succesfull.
  def creation_email(challenge_id)
    @challenge = Challenge.friendly.find(challenge_id)
    @owner = @challenge.owner
    mail( to: @owner.email, subject: "Bible Challenge #{@challenge.name} created!")
  end
 
  def snapshot_email(challenge)
    @challenge_snapshot = ChallengeSnapshot.new(challenge)
    mail( to: 'pdbradley@gmail.com', subject: "Challenge Status")
  end


end
