class MembershipMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  # Send an email to the user, when the membership creation is succesfull.
  def creation_email(membership)
    @membership = membership
    @challenge = @membership.challenge
    @user = @membership.user
    mail( to: @user.email, 
      subject: "#{@challenge.name} joined!", 
      from: "#{@challenge.name.capitalize} <no-reply@#{@challenge.subdomain}.biblechallenges.com>")
  end

  def auto_creation_email(membership)
    @membership = membership
    @challenge = @membership.challenge
    @user = @membership.user
    mail( to: @user.email, 
      subject: "#{@challenge.name} joined!", 
      from: "#{@challenge.name.capitalize} <no-reply@#{@challenge.subdomain}.biblechallenges.com>")    
  end

  def dailyreading_email(membership, reading)
    @membership = membership
    @chapter = reading.chapter
    @verses = @chapter.verses.by_version(membership.bible_version)
    @challenge = @membership.challenge
    @user = @membership.user
    @reading = reading
    mail( to: @user.email, 
      subject: "#{@challenge.name} reading: #{@chapter.book_name} #{@chapter.chapter_number}", 
      from: "#{@challenge.name.capitalize} <no-reply@#{@challenge.subdomain}.biblechallenges.com>")
  end


end
