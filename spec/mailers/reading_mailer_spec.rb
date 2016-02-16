require "spec_helper"

describe ReadingMailer do

  describe '.daily_reading_email' do

    it "sends a successful daily email" do
      user = create(:user)
      challenge = create(:challenge, :with_readings)
      create(:membership, user: user, challenge: challenge)

      expect{ ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now }.to_not raise_error
    end

    it "sends the email to the user's email" do
      user = create(:user)
      challenge = create(:challenge, :with_readings)
      create(:membership, user: user, challenge: challenge)
      ReadingMailer.daily_reading_email([challenge.readings.first.id], user.id).deliver_now

      successful_daily_email = ActionMailer::Base.deliveries.last
      expect(successful_daily_email.to).to match_array [user.email]
    end

  end

end
