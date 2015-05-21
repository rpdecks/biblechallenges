require 'spec_helper'

describe Member::ChallengesController do
  describe "Routing" do
    it { {get: "/member/challenges"}.should route_to(controller: "member/challenges", action: "index") }
  end

  let(:challengeowner) { create(:user) }
  let(:challenge) { create(:challenge, owner: challengeowner) }

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
    let!(:membership) {create(:membership, user: current_user, challenge: challenge)}

    before do
      sign_in :user, current_user
    end

    describe 'GET#index' do
      it "collects challenges into @challenges" do
        get :index
        expect(assigns(:challenges)).to match_array [challenge]
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end

