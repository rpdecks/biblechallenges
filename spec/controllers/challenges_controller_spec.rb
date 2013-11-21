require 'spec_helper'
require 'challenges_controller'

describe ChallengesController, "Routing" do

  let(:subdomainurl) { "http://woot.lvh.me" }
  it { {get: "#{subdomainurl}"}.should route_to(controller: "challenges", action: "show") }
  it { {get: "/challenges"}.should route_to(controller: "challenges", action: "index") }
end

describe ChallengesController, "Actions as a visitor" do
  render_views

  let(:challengeowner) { FactoryGirl.create(:user) }
  let(:challenge) { FactoryGirl.create(:challenge, subdomain: "woot", owner: challengeowner) }
  let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }

  context "on GET to #index" do

    it "should display a list of all the challenges" do
      get :index
      assigns(:challenges).should_not be_nil
    end
  end

  context "on GET to #show" do
    subject { get :show }

    before do
      request.host = "#{challenge.subdomain}.lvh.me"
    end

    it { assigns(:challenge).should_not be_nil }
    it { assigns(:readings).should_not be_nil }
  end

end

describe ChallengesController, "Actions as a user" do
  render_views

  let(:current_user) { FactoryGirl.create(:user) }
  let(:challengeowner) { FactoryGirl.create(:user) }
  let(:challenge) { FactoryGirl.create(:challenge, subdomain: "woot", owner: challengeowner) }
  let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }

  before { sign_in :user, current_user }

  context "on GET to #index" do

    it "should display a list of all the challenges" do
      get :index
      assigns(:challenges).should_not be_nil
    end
  end

end
