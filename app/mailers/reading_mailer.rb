class ReadingMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper 
  default from: "Bible Challenges <no-reply@biblechallenges.com>"
  layout 'default_mailer'

  def daily_reading_email(readings, member)
    @readings = Reading.find(readings)
    @reading_ids = @readings.map(&:id)
    @reading_date = @readings.first.read_on
    @challenge = @readings.first.challenge
    @user = User.find(member)
    @membership = Membership.where(user: @user, challenge: @challenge).first

  #  @reading = @readings.first
  #  @chapter = @reading.chapter

    unless @membership.nil?
      mail( to: @user.email,
           subject: "Bible Challenge reading for #{@challenge.name}",
      from: "#{@challenge.name.capitalize} <no-reply@biblechallenges.com>")
    end
  end



end
