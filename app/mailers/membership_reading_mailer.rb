class MembershipReadingMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  def daily_reading_email(membership_reading)
    @membership_reading = membership_reading
    @reading = @membership_reading.reading
    @membership = @membership_reading.membership
    @chapter = @reading.chapter
    @verses = @chapter.verses.by_version(@membership.bible_version)
    @challenge = @membership.challenge
    @user = @membership.user
    mail( to: @user.email, 
      subject: "#{@challenge.name} reading: #{@chapter.book_name} #{@chapter.chapter_number}", 
      from: "#{@challenge.name.capitalize} <no-reply@#{@challenge.subdomain}.biblechallenges.com>")
  end

end
