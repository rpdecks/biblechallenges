require 'spec_helper'

describe ImportsMembersFromPreviousChallenge do
  describe "#import" do
    it "imports members from previous challenge for creating a new challenge" do
      users = create_list(:user, 3)
      challenge = create(:challenge)
      challenge.join_new_member(users)
      imfpc = ImportsMembersFromPreviousChallenge.new(challenge)
      expect(imfpc.import).to eq users
    end
  end
end
