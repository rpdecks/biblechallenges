require 'spec_helper'

feature 'User logs reading via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'User links directly to profile page from the link at the bottom of the daily reading email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings)
    create(:membership, user: user, challenge: challenge)
    #todo needs fixing
    ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

    open_last_email
    visit_in_email("Wish to stop")

    expect(page).to have_content ("Update User Profile")
  end

#  scenario 'User opts out of daily chapter email, and is bypassed on the daily reading email.' do
#
#    user = create(:user)
#    challenge = create(:challenge, :with_readings, chapters_to_read: "Mat 1-2", num_chapters_per_day: 2)
#    create(:membership, user: user, challenge: challenge)
#    reading_ids = challenge.readings.pluck(:id)
#    ReadingMailer.daily_reading_email(reading_ids, user.id).deliver_now
#
#    open_last_email
#    visit_in_email("Wish to stop")
#    # meta click radio_button (stop sending daily reading email)
#    click_button 'Update'
#
#    expect{
#    ReadingMailer.daily_reading_email(reading_ids, user.id).To.value
#    }.not_to eq user.email
#  end
#
#  scenario 'User opts out of comment-notify emails, and is bypassed on the comment-notify mailer.' do
#
#    user = create(:user)
#    challenge = create(:challenge, :with_readings, chapters_to_read: "Mat 1-2", num_chapters_per_day: 2)
#    create(:membership, user: user, challenge: challenge)
#    reading_ids = challenge.readings.pluck(:id)
#    ReadingMailer.daily_reading_email(reading_ids, user.id).deliver_now
#
#    open_last_email
#    visit_in_email("Wish to stop")
#    # meta click radio_button (stop sending daily reading email)
#    click_button 'Update'
#
#    expect{
#    ReadingMailer.daily_reading_email(reading_ids, user.id).To.value
#    }.not_to eq user.email
#  end
end
