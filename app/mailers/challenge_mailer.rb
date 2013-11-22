class ChallengeMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"

  # Send an email to the user, when the Challenge creation is succesfull.
  def creation_email(challenge)
    @owner = challenge.owner
    mail( to: @owner.email, subject: 'Testing')
  end

end
