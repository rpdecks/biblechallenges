class MessageMailer < ActionMailer::Base
  default from: "Bible Challenges <no-reply@biblechallenges.com>"

  def message_all_users_email(email, message, challenge)
    @message = message
    @challenge = challenge

    mail(
      to: email,
      subject: "#{challenge.name} challenge owner #{challenge.owner.name} sent you a message"
    )
  end
end
