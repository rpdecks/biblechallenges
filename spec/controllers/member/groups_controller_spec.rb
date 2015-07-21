require 'spec_helper'

describe Member::GroupsController, type: :controller do

  let(:user){create(:user)}

  before do
    sign_in :user, user
  end



  describe  'POST#create' do
    it "associates statistics with group" do
      challenge = create(:challenge)
      create(:membership, user: user, challenge: challenge)
      number_of_stats = GroupStatistic.descendants.size
      expect {
        post :create, challenge_id: challenge, group: attributes_for(:group)
      }.to change(GroupStatistic, :count).by(number_of_stats) 
    end
  end
end
