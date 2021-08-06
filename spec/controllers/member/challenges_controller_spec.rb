require 'spec_helper'

describe Member::ChallengesController do
  describe "Routing" do
    specify { expect({get: "/member/challenges"}).to route_to(controller: "member/challenges", action: "index") }
  end

  describe 'Guest access' do
    describe 'GET#index' do
      it "does not renders the :index template" do
        get :index
        expect(response).to_not render_template(:index)
      end

      it "redirects to the log in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'User access' do
    let(:current_user) { create(:user) }

    before do
      sign_in current_user, scope: :user
    end

    describe 'GET#index' do
      it "collects challenges into @challenges" do
        current_challenge = create(:challenge, :with_membership, owner: current_user)
        #create(:membership, user: current_user, challenge: current_challenge)
        get :index
        expect(assigns(:challenges)).to match_array [current_challenge]
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end

