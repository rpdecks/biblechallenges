class ReadingMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  def daily_reading_email(reading, membership)
    @reading = Reading.find(reading)
    @reading_date = Date.today
    @membership = membership
    @chapter = @reading.chapter
    @verses = @chapter.verses.by_version(@membership.bible_version)
    @challenge = @membership.challenge
    @user = @membership.user
    mail( to: @user.email,
      subject: "Bible Challenge reading for #{@challenge.name} : #{@chapter.book_name} #{@chapter.chapter_number}",
      from: "#{@challenge.name.capitalize} <no-reply@biblechallenges.com>")
  end



end
