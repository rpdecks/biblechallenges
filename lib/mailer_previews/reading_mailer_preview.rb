class ReadingMailerPreview < ActionMailer::Preview
  def daily_reading_email
    email = ('a'..'z').to_a.shuffle[0,8].join
    @owner = User.create(name: "Eric", email: "#{email}@gmail.com", password: '123123')
    @challenge = Challenge.create(num_chapters_per_day: 2, name: "Super Challenge!", owner: @owner, chapters_to_read: "Mat 1-5", begindate: Date.today)
    ReadingsGenerator.new(@challenge).generate
    @membership = Membership.create(challenge: @challenge, user: @owner, bible_version: 'KJV')
    @readings = @challenge.readings.todays_readings
    @user = @challenge.owner
    ReadingMailer.daily_reading_email(@readings.pluck(:id), @owner)
  end
end
