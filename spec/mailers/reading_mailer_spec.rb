require "spec_helper"

describe ReadingMailer do

  describe '.daily_reading_email' do
    let(:user){create(:user, :with_profile)}
    let(:challenge){create(:challenge_with_readings)}
    let(:membership){challenge.join_new_member(user)}
    let!(:reading){challenge.readings.first}

    it "sends a successful daily email" do
      expect{ ReadingMailer.daily_reading_email(reading, membership).deliver_now }.to_not raise_error
    end

    it "sends the email to the user's email" do
      pending
      successful_daily_email = ActionMailer::Base.deliveries.last
      expect(successful_daily_email.to).to match_array [user.email]
    end

  end

end
