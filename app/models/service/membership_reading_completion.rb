class MembershipReadingCompletion
  def initialize(user, membership, membership_reading)
    @user = user
    @challenge = membership.challenge
    @membership_reading = membership_reading
    @group = membership.group if membership.group
  end

  def attach_attributes
    @membership_reading.user_id = @user.id
    @membership_reading.challenge_id = @challenge.id
    @membership_reading.challenge_name= @challenge.name
    @membership_reading.chapter_id = @membership_reading.chapter.id
    @membership_reading.chapter_name = @membership_reading.chapter.book_and_chapter
    @membership_reading.group_name = @group.name if @group
    @membership_reading.group_id = @group.id if @group
    @membership_reading.save
  end
end
