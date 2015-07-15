class ReadingMailerPreview < ActionMailer::Preview
  def daily_reading_email
    email = ('a'..'z').to_a.shuffle[0,8].join
    @owner = User.create(email: "#{email}@gmail.com", password: '123123')
    @challenge = Challenge.create(name: "Super Challenge!", owner: @owner, chapters_to_read: "Mat 1-5", begindate: Date.today)
    @membership = Membership.create(challenge: @challenge, user: @owner, bible_version: 'KJV')
    @challenge.generate_readings
    @reading = @challenge.readings.first
    @reading_date = @reading.read_on
    @user = @challenge.owner
    @chapter = @reading.chapter
    @verses = @chapter.verses.by_version(@membership.bible_version)
    ReadingMailer.daily_reading_email(@reading, @owner)
  end
end
