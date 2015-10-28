require 'spec_helper'

describe ImportsMembersFromPreviousChallenge do
  describe "#import" do
    it "imports members from previous challenge for creating a new challenge" do
      users = create_list(:user, 3)
      owner = double
      challenge = build_stubbed(:challenge)
      old_challenge = double(:old_challenge, id: challenge.id, owner: owner, members: users)
      new_challenge = double(:new_challenge, owner: owner, members: [])
      allow(Challenge).to receive(:find).and_return(old_challenge)

      ImportsMembersFromPreviousChallenge.new(old_challenge.id, new_challenge).import

      expect(old_challenge.members).to match_array new_challenge.members
    end
  end
end
