class MembershipReadingCompletion
  def initialize(user, challenge, membership_reading)
    @user = user
    @challenge = challenge
    @membership_reading = membership_reading
  end

  def attach_attributes
    @membership_reading.user_id = @user.id
    @membership_reading.challenge_id = @challenge.id
    @membership_reading.challenge_name= @challenge.name
    @membership_reading.chapter_id = @membership_reading.chapter.id
    @membership_reading.chapter_name = @membership_reading.chapter.book_and_chapter
    @membership_reading.save
  end
end
