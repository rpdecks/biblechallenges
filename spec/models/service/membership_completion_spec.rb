require 'spec_helper'

# jose is this a good use of mocks?
describe MembershipCompletion do

  describe "MembershipStatistics" do
    it "should attach user statistics to the user" do
      allow(MembershipStatisticAttacher).to receive(:attach_statistics)
      ch = create(:challenge, :with_membership, :with_readings)
      membership = ch.memberships.first

      MembershipCompletion.new(membership)

      expect(MembershipStatisticAttacher).to have_received(:attach_statistics).exactly(1).times
    end
  end

  describe "Created membership email and daily reading email" do

    before(:each) do
      challenge = build_stubbed(:challenge, :with_readings, owner: build_stubbed(:user))
      @membership = build_stubbed(:membership, challenge: challenge, user: challenge.owner)
    end

    it "sends the successful creation email" do
      allow(@membership).to receive(:successful_creation_email)

      MembershipCompletion.new(@membership)

      expect(@membership).to have_received(:successful_creation_email).exactly(1).times
    end
    it "sends the daily reading email" do
      allow(@membership).to receive(:send_reading_email)

      MembershipCompletion.new(@membership)

      expect(@membership).to have_received(:send_reading_email).exactly(1).times
    end
    it "sends the auto creation email when there is a password" do
      # how do you check that a message was NOT sent jose
      allow(@membership).to receive(:successful_auto_creation_email)
      allow(@membership).to receive(:successful_creation_email)
      MembershipCompletion.new(@membership, password: "yeahbuddy")

      expect(@membership).not_to have_received(:successful_creation_email)
      expect(@membership).to have_received(:successful_auto_creation_email).exactly(1).times
    end

  end




end
