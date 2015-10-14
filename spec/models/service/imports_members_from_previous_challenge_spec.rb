require 'spec_helper'

describe ImportsMembersFromPreviousChallenge do
  describe "#import" do
    it "imports members from previous challenge for creating a new challenge" do
      users = create_list(:user, 3)
      old_challenge = create(:challenge, owner_id: users.first.id)
      old_challenge.join_new_member(users)
      new_challenge = create(:challenge, owner_id: users.first.id)
      ImportsMembersFromPreviousChallenge.new(old_challenge.id, new_challenge).import
      new_challenge.reload
      expect(old_challenge.members).to eq new_challenge.members
    end
  end
end
