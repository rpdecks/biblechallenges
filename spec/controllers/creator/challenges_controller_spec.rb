require 'spec_helper'

describe Creator::ChallengesController do
  render_views

  describe "Routing" do
    it { {get: "/creator/challenges"}.should route_to(controller: "creator/challenges", action: "index") }
  end

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
    let(:challenge_creator) { create(:user) }
    let(:challenge) { create(:challenge, owner: challenge_creator) }

    before :each do
      sign_in :user, challenge_creator
    end

    describe "DELETE#destroy" do
      it "redirects to the challenges page" do
        delete :destroy, id: challenge
        expect(response).to redirect_to member_challenges_url
      end

      it "removes challenge from database" do
        challenge
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
      describe "with invalid attributes" do
        it "renders new template again" do
          post :create, challenge: FactoryGirl.attributes_for(:challenge, name: nil)
          expect(response).to render_template(:new)
        end
      end
      describe "with invalid attributes as a challenge owner" do
        it "renders new template again" do
          challenge #makes user a challenge owner
          post :create, challenge: FactoryGirl.attributes_for(:challenge, name: nil)
          expect(response).to render_template(:new)
        end
      end
      describe "with valid attributes" do
        it "joins the creator to the challenge he created" do
          expect{
            post :create, challenge: FactoryGirl.attributes_for(:challenge)
          }.to change(Challenge, :count).by(1)

          expect(Challenge.first.members).to include challenge_creator
        end

        it "creates a book_chapters array of parsed book chapter values" do
          post :create, challenge: FactoryGirl.attributes_for(:challenge, chapters_to_read: "Matt 1")
 
          expect(Challenge.first.book_chapters).to match_array  [[40,1]]
        end
        it "creates a serialized challenge attribute array days_of_week_to_skip" do
          post :create, challenge: FactoryGirl.attributes_for(:challenge, days_of_week_to_skip: ['0','1'])

          expect(Challenge.first.days_of_week_to_skip).to match_array  [0,1]
        end
        it "saves dates to skip" do
          post :create, challenge: FactoryGirl.attributes_for(:challenge, dates_to_skip: "2017-01-01")

          expect(Challenge.first.dates_to_skip).to eq "2017-01-01"
        end
      end
      describe "with past challenge members attributes" do
        it "creates the challenge with past challenge members to the challenge he created" do
          previous_challenge = create(:challenge, :with_membership, owner: challenge_creator)
          user1 = create(:user)
          user2 = create(:user)
          user3 = create(:user)
          previous_challenge.join_new_member([user1, user2, user3])
          new_challenge_params = FactoryGirl.attributes_for(:challenge)
          new_challenge_params[:previous_challenge_id] = previous_challenge.id
          post :create, challenge: new_challenge_params
          new_challenge = Challenge.last

          expect(new_challenge.members).to include user1, user2, user3
        end
      end
    end
  end
end

