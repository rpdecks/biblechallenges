require 'spec_helper'

feature 'Owner manages group members within challenge' do
  let(:user) {create(:user)}

  before(:each) do
    login(user)
  end

  scenario 'Adds a challenge member to a goup within the challenge' do
    user2 = create(:user)
    challenge = create(:challenge, owner_id: user.id, name: "Wonderful")
    create(:membership, challenge: challenge, user: user)
    create(:group, challenge_id: challenge.id, user_id: user.id)

    visit creator_challenge_path(challenge)


  end

  scenario 'Changes challenge group member to another group within same challenge' do
  end
end


