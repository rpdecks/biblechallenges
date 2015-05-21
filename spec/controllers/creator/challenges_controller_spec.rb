require 'spec_helper'

describe Creator::ChallengesController do

  describe "Routing" do
    it { {get: "/creator/challenges"}.should route_to(controller: "creator/challenges", action: "index") }
  end

  let(:challenge_creator) { create(:user) }
  let(:challenge) { create(:challenge, owner: challenge_creator) }

  describe 'Unauthorized access' do
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

  describe 'Creator access' do
    before do
      sign_in :user, challenge_creator
    end

    describe "DELETE#destroy" do
      it "redirects to the challenges page" do
        delete :destroy, id: challenge
        expect(response).to redirect_to creator_challenges_url
      end

      it "removes challenge from database" do
        expect {
         delete :destroy, id: challenge
        }.to change(Challenge, :count).by(-1)
      end
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

    describe 'GET#new' do
      it "sets up a new empty challenge" do
        get :new
        expect(assigns(:challenge)).to be_a_new(Challenge)
      end

      it "renders the :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      describe "with valid attributes" do
        it "creates a new challenge" do
          expect {
            post :create, challenge: attributes_for(:challenge)
          }.to change(Challenge, :count).by(1)
        end
      end
    end
  end
end

