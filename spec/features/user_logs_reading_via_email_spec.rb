require 'spec_helper'

feature 'User logs reading via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'User logs his reading from the link at the bottom of the daily reading email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings)
    create(:membership, user: user, challenge: challenge)
    ReadingMailer.daily_reading_email(challenge.readings.first.id, user.id).deliver_now

    expect{
    open_last_email
    visit_in_email("Confirm")
    }.to change(user.membership_readings, :count).by(1)

    expect(page).to have_content ("Thank you")
  end
end


