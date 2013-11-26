class ChallengeMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  # Send an email to the user, when the Challenge creation is succesfull.
  def creation_email(challenge)
    @challenge = challenge
    @owner = @challenge.owner    
    mail( to: @owner.email, subject: "#{@challenge.name} created!")
  end

end
