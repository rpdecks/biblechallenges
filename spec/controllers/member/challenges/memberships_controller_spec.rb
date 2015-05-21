require 'spec_helper'

describe Member::MembershipsController do
  let(:owner){create(:user)}
  let(:challenge){create(:challenge, owner: owner)}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}

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
    let!(:membership){challenge.join_new_member(current_user)}
    describe 'GET#show  (my-membership)' do
      it "finds the current_user membership" do
        somechallenge = create(:challenge)  #uses factorygirl
        membership = somechallenge.join_new_member(current_user)

        get :show, challenge_id: somechallenge.id

        expect(assigns(:membership)).to eql(membership)
      end

      it "renders the :show template" do
        somechallenge = create(:challenge)  #uses factorygirl
        somechallenge.join_new_member(current_user)

        get :show, challenge_id: somechallenge.id

        expect(response).to render_template :show
      end
    end
  end
end
