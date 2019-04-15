class ReadingMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  def daily_reading_email(readings, member)
    @readings = Reading.where(id: readings).limit(Reading::DAILY_LIMIT)
    @reading_ids = @readings.map(&:id)
    @reading_date = @readings.first.read_on
    @challenge = @readings.first.challenge
    @user = User.find(member)
    @membership = Membership.where(user: @user, challenge: @challenge).first

    unless @membership.nil?
      EmailLog.create(event: "Deliver",
                      challenge_id: @challenge.id,
                      user_id: @user.id,
                      email: @user.email,
                      time_zone: @user.time_zone,
                      preferred_reading_hour: @user.preferred_reading_hour,
                      readings: readings)
      #include readings

      mail(
        to: @user.email,
        subject: "#{@challenge.name.first(12)}...BibleChallenges.com reading - #{@reading_date.strftime("%B %d")}: #{@readings.first.chapter.book_and_chapter}..."
      )
    end
  end
end
