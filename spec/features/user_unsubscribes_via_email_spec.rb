require 'spec_helper'

feature 'User unsubscribes via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'User unsubscribes from a challenge via the link in the daily email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings)
    create(:membership, user: user, challenge: challenge)
    ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

    open_last_email
    path = parse_email_for_link(current_email, "Manage your notification preferences.")# the link is Click *here* to unsubsubscribe
    login(user)
    visit(path)
    expect(page.body).to include('Email Preferences')
  end
end


