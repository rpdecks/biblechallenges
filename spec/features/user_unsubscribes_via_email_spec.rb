require 'spec_helper'

feature 'User unsubscribes via email' do

  scenario 'User unsubscribes from a challenge via the link in the daily email' do
    user = create(:user, :with_profile, email: 'phil@phil.com')
    challenge = create(:challenge, :with_readings)
    membership = create(:membership, user: user, challenge: challenge)

    ReadingMailer.daily_reading_email(challenge.readings.first, membership).deliver

    b = open_last_email
    binding.pry



  end

end


