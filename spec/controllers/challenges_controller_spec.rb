require 'spec_helper'
require 'challenges_controller'


describe ChallengesController do

  describe "Routing" do

    let(:subdomainurl) { "http://woot.lvh.me" }
    it {expect({get: "#{subdomainurl}"}).to route_to(controller: 'memberships', action: 'new') }
    it { {get: "/challenges"}.should route_to(controller: "challenges", action: "index") }

  end


  describe 'Guest access' do

    let(:challengeowner) { create(:user) }
    let(:challenge) { create(:challenge, subdomain: "woot", owner: challengeowner) }
    let(:subdomainurl) { "http://#{challenge.subdomain}.lvh.me" }

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


    describe 'GET#show' do

      # before do
      #   request.host = "#{challenge.subdomain}.lvh.me"
      # end

      # it "locates the requested challenge" do
      #   get :show
      #   assigns(:challenge).should eq(challenge)      
      # end
      # subject { get :show }

      # it { expect(assigns(:challenge)).to_not be_nil }
      # it { assigns(:readings).should_not be_nil }

    end

  end

  describe 'User access' do
    let(:current_user) { create(:user) }

    before do
      sign_in :user, current_user
    end

  end

end

# describe ChallengesController, "Actions as a visitor" do
#   render_views

#   let(:challengeowner) { FactoryGirl.create(:user) }
#   let(:challenge) { FactoryGirl.create(:challenge, subdomain: "woot", owner: challengeowner) }
#   let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }

#   context "on GET to #index" do

#     it "should display a list of all the challenges" do
#       get :index
#       assigns(:challenges).should_not be_nil
#     end
#   end

#   context "on GET to #show" do
#     subject { get :show }

#     before do
#       request.host = "#{challenge.subdomain}.lvh.me"
#     end

#     it { assigns(:challenge).should_not be_nil }
#     it { assigns(:readings).should_not be_nil }
#   end

# end

# describe ChallengesController, "Actions as a user" do
#   render_views

#   let(:current_user) { FactoryGirl.create(:user) }
#   let(:challengeowner) { FactoryGirl.create(:user) }
#   let(:challenge) { FactoryGirl.create(:challenge, subdomain: "woot", owner: challengeowner) }
#   let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }

#   before { sign_in :user, current_user }

#   context "on GET to #index" do

#     it "should display a list of all the challenges" do
#       get :index
#       assigns(:challenges).should_not be_nil
#     end
#   end

# end
