require 'spec_helper'

feature 'User logs reading via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'For a one chapter per day challenge, user logs his reading from the link at the bottom of the daily reading email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings)
    create(:membership, user: user, challenge: challenge)
    #todo needs fixing
    ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

    expect{
    open_last_email
    visit_in_email("Confirm")
    }.to change(user.membership_readings, :count).by(1)

    expect(page).to have_content ("Thank you")
  end

  scenario 'For a two chapter per day challenge, user logs his reading from the link at the bottom of the daily reading email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings, chapters_to_read: "Mat 1-2", num_chapters_per_day: 2)
    create(:membership, user: user, challenge: challenge)
    reading_ids = challenge.readings.pluck(:id)
    ReadingMailer.daily_reading_email(reading_ids, user.id).deliver_now

    expect{
    open_last_email
    visit_in_email("Confirm")
    }.to change(user.membership_readings, :count).by(2)
    binding.pry

    expect(page).to have_content ("Thank you")
  end

end


