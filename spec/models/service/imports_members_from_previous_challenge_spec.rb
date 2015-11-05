require 'spec_helper'

describe ImportsMembersFromPreviousChallenge do

  describe "#import" do
    it "Generates memberships for a new challenge if the challenges are owned by the same person" do
      owner = double
      old_challenge = double(:old_challenge, owner: owner, members: double)
      new_challenge = double(:new_challenge, owner: owner)
      allow(MembershipGenerator).to receive_message_chain(:new, :generate)

      ImportsMembersFromPreviousChallenge.new(old_challenge, new_challenge).import

      expect(MembershipGenerator).to have_received(:new).with(new_challenge, old_challenge.members)
    end

    it "Does not generates memberships for a new challenge if the challenges are owned by different people" do
      old_challenge = double(:old_challenge, owner: double, members: double)
      new_challenge = double(:new_challenge, owner: double)
      allow(MembershipGenerator).to receive_message_chain(:new, :generate)

      ImportsMembersFromPreviousChallenge.new(old_challenge, new_challenge).import

      expect(MembershipGenerator).not_to have_received(:new)
    end

    it "Does not generates memberships for a new challenge if the challenge to import is nil" do
      old_challenge = nil
      new_challenge = double(:new_challenge, owner: double)
      allow(MembershipGenerator).to receive_message_chain(:new, :generate)

      ImportsMembersFromPreviousChallenge.new(old_challenge, new_challenge).import

      expect(MembershipGenerator).not_to have_received(:new)
    end
  end
end
