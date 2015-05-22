require 'spec_helper'

describe Member::MembershipsController do
  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}

  before(:each) do
    sign_in :user, user
  end

  describe  'POST#create' do
    let(:newchallenge){create(:challenge, owner: owner)}

    it "redirects to the challenge page after joining as a logged in user" do
      somechallenge = create(:challenge)  #uses factorygirl
      post :create, challenge_id: somechallenge.id
      expect(response).to redirect_to somechallenge
    end

    it "creates a membership" do
      expect {
        post :create, challenge_id: newchallenge
      }.to change(Membership, :count).by(1)

    end
  end

  context 'when the user has already joined' do
    describe 'GET#show  (my-membership)' do
      it "finds the current_users membership" do
        get :show, id: membership.id
        expect(assigns(:membership)).to eql(membership)
      end

      it "renders the :show template" do
        get :show, id: membership.id
        expect(response).to render_template :show
      end
    end
  end
end
