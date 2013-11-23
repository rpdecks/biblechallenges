require 'spec_helper'
require 'challenges_controller'


describe ChallengesController do

  describe "Routing" do

    let(:subdomainurl) { "http://woot.lvh.me" }
    it {expect({get: "#{subdomainurl}"}).to route_to(controller: 'challenges', action: 'show') }
    it { {get: "/challenges"}.should route_to(controller: "challenges", action: "index") }

  end

  let(:challengeowner) { create(:user) }
  let(:challenge) { create(:challenge, subdomain: "woot", owner: challengeowner) }
  let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }

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

      ## Should this be the desired behavior ?
      # it "displays a list of all the challenges" do
      #   get :index
      #   assigns(:challenges).should_not be_nil
      # end

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

# describe ChallengesController, "Actions as a visitor" do

#   context "on GET to #show" do
#     subject { get :show }

#     before do
#       request.host = "#{challenge.subdomain}.lvh.me"
#     end

#     it { assigns(:challenge).should_not be_nil }
#     it { assigns(:readings).should_not be_nil }
#   end

# end
