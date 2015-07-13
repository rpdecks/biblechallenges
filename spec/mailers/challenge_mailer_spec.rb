require "spec_helper"

describe ChallengeMailer do

  describe '.creation_email' do

    let(:owner){create(:user)}
    let(:challenge){build(:challenge, owner: owner)}

    it "sends a successful creation email" do
      expect{ ChallengeMailer.creation_email(challenge).deliver_now }.to_not raise_error
    end

    before {challenge.save}

    it "sends the email to the owner's email" do
      Sidekiq::Extensions::DelayedMailer.drain
      successful_creation_email = ActionMailer::Base.deliveries.last
      expect(successful_creation_email.to).to match_array [owner.email] 
    end
  end
end
