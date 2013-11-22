require "spec_helper"

describe ChallengeMailer do

  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}

  describe '.send_creation_email' do
    it "sends a successful creation email" do
      expect{ ChallengeMailer.send_creation_email(challenge).deliver }.to_not raise_error
    end
  end

end
