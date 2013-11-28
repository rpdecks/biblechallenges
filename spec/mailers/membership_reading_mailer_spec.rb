require "spec_helper"

describe MembershipReadingMailer do

  describe '.daily_reading_email' do
    let(:user){create(:user)}
    let(:challenge){create(:challenge)}
    let(:membership){challenge.join_new_member(user)}
    let!(:membership_reading){membership.membership_readings.first}

    it "sends a successful daily email" do
      expect{ MembershipReadingMailer.daily_reading_email(membership_reading).deliver }.to_not raise_error
    end

    it "sends the email to the user's email" do
      successful_daily_email = ActionMailer::Base.deliveries.last
      expect(successful_daily_email.to).to match_array [user.email]
    end

    it "has email's from like no-reply@subdomain.biblechallenges.com" do
      successful_daily_email = ActionMailer::Base.deliveries.last
      expect(successful_daily_email.from).to match_array ["no-reply@#{challenge.subdomain}.biblechallenges.com"] 
    end

  end

end
