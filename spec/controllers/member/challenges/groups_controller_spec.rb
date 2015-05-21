require 'spec_helper'

describe Member::GroupsController, type: :controller do

  let(:user){create(:user)}
  let(:challenge){create(:challenge)}

  before do
    sign_in :user, user
  end

  describe 'GET#show' do
    it "redirects to the group show page" do
      group = create(:group, challenge_id: challenge.id, user: user)
      get :show, challenge_id: challenge.id, id: group.id
      expect(response).to render_template :show
    end
  end
end
