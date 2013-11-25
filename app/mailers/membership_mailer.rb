class MembershipMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'


  # Send an email to the user, when the membership creation is succesfull.
  def creation_email(membership)
    @membership = membership
    @user = @membership.user    
    mail( to: @user.email, 
      subject: "@challenge.name joined!", 
      from:"#{@membership.challenge.name.capitalize} <no-reply@#{@membership.challenge.subdomain}.biblechallenges.com>")
  end

end
