require 'spec_helper'

feature 'User unsubscribes via email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'User unsubscribes from a challenge via the link in the daily email' do

    user = create(:user)
    challenge = create(:challenge, :with_readings)
    create(:membership, user: user, challenge: challenge)
    ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

    expect{
    open_last_email
    path = parse_email_for_link(current_email, "HERE")# the link is Click *here* to unsubsubscribe
    visit(path)
    click_button("Unsubscribe")
    }.to change(Membership, :count).by(-1)

  end
end


