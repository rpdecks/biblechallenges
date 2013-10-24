require 'spec_helper'

describe ChallengesController, "Routing" do

  it { {get: '/challenges/new'}.should route_to(controller: "challenges", action: "new") }
  it { {post: '/challenges'}.should route_to(controller: "challenges", action: "create") }

end

describe ChallengesController, "Actions as a logged in user" do
  let(:current_user) { FactoryGirl.create(:user) }

  before do
    sign_in :user, current_user
  end

  context "on GET to #new" do
    it "should display the new challenge form" do
      get :new
      response.should be_success
    end
  end

  context "on POST to #create" do
    it "should create a new challenge" do
      expect {
        post :create, challenge: FactoryGirl.attributes_for(:challenge)
      }.to change(Challenge, :count).by(1)
    end
  end
end

describe ChallengesController, "Actions as a logged out user" do

  context "on GET to #new" do
    it "should not display the new challenge form" do
      get :new
      response.should_not be_success
    end

    it "should redirect to the log in page" do
      get :new 
      response.should redirect_to(new_user_session_path)
    end
  end
end
