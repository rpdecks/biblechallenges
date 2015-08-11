require 'spec_helper'

feature 'User manages notification preferences via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  feature 'From daily reading emails' do
    scenario 'User links directly to profile page from the link at the bottom of the daily reading email' do
      user = create(:user)
      login(user)
      challenge = create(:challenge, :with_readings)
      create(:membership, user: user, challenge: challenge)
      #todo needs fixing
      ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

      open_last_email
      visit_in_email("Manage your notification preferences.")
      expect(page).to have_content ("Receive daily readings by email?")
    end

    scenario 'User gets redirected to sign-in page if not signed in' do
      user = create(:user)
      challenge = create(:challenge, :with_readings, chapters_to_read: "Mat 1-2", num_chapters_per_day: 2)
      create(:membership, user: user, challenge: challenge)
      reading_ids = challenge.readings.pluck(:id)
      ReadingMailer.daily_reading_email(reading_ids, user.id).deliver_now

      open_last_email
      visit_in_email("Manage your notification preferences.")
      expect(page).to have_content("Log in")
    end

    scenario 'User updates daily reading email preferences' do
      user = create(:user)
      login(user)
      challenge = create(:challenge, :with_readings)
      create(:membership, user: user, challenge: challenge)
      ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

      open_last_email
      visit_in_email("Manage your notification preferences.")
      expect(page).to have_content ("Receive daily readings by email?")
      uncheck('user_reading_notify')
      click_button 'Update'
      user.reload
      expect(user.reading_notify).to be_falsey
    end
  end

  feature 'From comment emails' do
    scenario 'User opts out of comment-notify emails, and is bypassed on the comment-notify mailer.' do
      user2 = create(:user)
      challenge = create(:challenge, :with_readings, owner_id: user2.id)
      group = create(:group, challenge: challenge)
      original_comment = create(:group_comment, user: user2, commentable: group)

      user = create(:user)
      login(user)
      challenge.join_new_member(user)
      new_comment = create(:group_comment, commentable: original_comment, user: user, content: "cool dude")
      CommentMailer.new_comment_notification(new_comment).deliver_now
      open_last_email
      visit_in_email("here")
      uncheck('user_comment_notify')
      click_button 'Update'
      user.reload
      expect(user.comment_notify).to be_falsey
    end
  end
  feature 'From admin/creator message emails' do
    scenario 'User opts out of admin-message emails.' do
      user = create(:user)
      login(user)
      create(:challenge, :with_readings)
      original_comment = create(:group_comment, user: user2)
      new_comment = create(:group_comment, commentable: original_comment, user: user, content: "cool dude")
      CommentMailer.new_comment_notification(new_comment).deliver_now
      open_last_email
      visit_in_email("here")
      uncheck('user_comment_notify')
      click_button 'Update'
      user.reload
      expect(user.comment_notify).to be_falsey
    end
  end
end
