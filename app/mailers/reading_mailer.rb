class ReadingMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  def daily_reading_email(reading, member)
    @reading = Reading.find(reading)
    @chapter = @reading.chapter
    @reading_date = @reading.read_on
    @challenge = @reading.challenge
    @user = User.find(member)
    @membership = Membership.where(user: @user, challenge: @challenge).first
    unless @membership.nil?
      @verses = @chapter.verses.by_version(@membership.bible_version)
      mail( to: @user.email,
           subject: "Bible Challenge reading for #{@challenge.name} : #{@chapter.book_name} #{@chapter.chapter_number}",
      from: "#{@challenge.name.capitalize} <no-reply@biblechallenges.com>")
    end
  end



end
