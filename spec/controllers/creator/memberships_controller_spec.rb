require 'spec_helper'

describe Creator::MembershipsController do

  describe "POST #update" do

    it "changes the group id of a membership within the same challenge" do
      user = create(:user)
      sign_in user

      challenge = create(:challenge, owner_id: user.id)
      group1 = create(:group, challenge_id: challenge.id)
      group2 = create(:group, challenge_id: challenge.id)
      membership = create(:membership, group_id: group1.id, challenge_id: challenge.id)

      post :update, id: membership.id, group_id: group2.id, challenge_id: challenge.id
      membership.reload
      expect(membership.group_id).to eq group2.id
    end
  end
end
