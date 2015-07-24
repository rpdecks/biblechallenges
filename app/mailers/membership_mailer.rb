class MembershipMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper

  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  # Send an email to the user, when the membership creation is succesfull.
  def creation_email(membership_id)
    @membership = Membership.find(membership_id)
    @challenge = @membership.challenge
    @user = @membership.user
    mail( to: @user.email,
      subject: "#{@challenge.name}: Thanks for joining!",
      from: "#{@challenge.name.capitalize} <no-reply@biblechallenges.com>")
  end

  def auto_creation_email(membership_id, password)
      @password = password
      @membership = Membership.find(membership_id)
      @challenge = @membership.challenge
      @user = @membership.user
      mail( to: @user.email,
        subject: "#{@challenge.name}: Thanks for joining!",
        from: "#{@challenge.name.capitalize} <no-reply@biblechallenges.com>")
  end

end
