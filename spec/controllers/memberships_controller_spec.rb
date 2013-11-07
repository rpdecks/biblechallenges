require 'spec_helper'

describe MembershipsController, "Routing" do
  
  it { { get: '/memberships/'}.should route_to(controller: "memberships", action: "index") }

end

describe MembershipsController, "Actions as a logged in user" do
  let(:current_user) { FactoryGirl.create(:user) }

  before do
    sign_in :user, current_user
  end

  context "on GET to #index" do
    it "should render the index template" do
      get :index 
      should render_template("memberships/index")
    end

    it "assigns the current user's memberships" do
      FactoryGirl.create(:membership, user: current_user)
      get :index
      assigns(:memberships).should_not be_nil
    end
  end
end
