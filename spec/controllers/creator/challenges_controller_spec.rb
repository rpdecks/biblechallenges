require 'spec_helper'
require 'creator/challenges_controller'

describe Creator::ChallengesController do

  let(:challenge) {create(:challenge)}

  describe 'Routing' do
    it { expect({get: '/creator/challenges/new'}).to route_to(controller: 'creator/challenges', action: 'new') }
    it { expect({post: '/creator/challenges'}).to route_to(controller: 'creator/challenges', action: 'create') }
  end

  describe 'User access' do
    let(:current_user) {create(:user)}
    let(:challenge) {create(:challenge, owner: current_user)}

    before do
      sign_in :user, current_user
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

    describe 'GET#edit' do
      it "finds the right challenge" do
        get :edit, id: challenge
        expect(assigns(:challenge)).to eql(challenge)
      end

      it "renders the :edit template" do
        get :edit, id: challenge
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      context "with valid attributes" do

        it "creates a new challenge" do
          expect {
            post :create, challenge: attributes_for(:challenge)
          }.to change(Challenge, :count).by(1)
        end

        it "redirects to the new challenge" do
          post :create, challenge: attributes_for(:challenge)
          expect(response).to redirect_to creator_challenge_path Challenge.last
        end

      end

      context "with invalid attributes" do

        it "does not save the new challenge" do
          expect{
            post :create, challenge: attributes_for(:invalid_challenge)
          }.to_not change(Challenge,:count)
        end

        it "re-renders the new method" do
          post :create, challenge: attributes_for(:invalid_challenge)
          expect(response).to render_template :new
        end

      end
    end

  end

  describe 'Guest access' do

    describe 'GET#new' do
      it "does not renders the :new template" do
        get :new
        expect(response).to_not render_template(:new)
      end

      it "redirects to the log in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET#confirm_destroy' do
      it "does not renders the :new template" do
        get :confirm_destroy, id: challenge
        expect(response).to_not render_template(:confirm_destroy)
      end

      it "redirects to the log in page" do
        get :confirm_destroy, id: challenge
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE#destroy' do
      it "redirects to the log in page" do
        delete :destroy, id: challenge
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET#edit' do
      it "does not renders the :new template" do
        get :edit, id: challenge
        expect(response).to_not render_template(:edit)
      end

      it "redirects to the log in page" do
        get :edit, id: challenge
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST #create" do
      it "does not create a new Challenge" do
        expect {
          post :create, challenge: attributes_for(:challenge)
        }.not_to change(Challenge, :count)
      end

      it "redirects to the log in page" do
        post :create, challenge: attributes_for(:challenge)
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

end