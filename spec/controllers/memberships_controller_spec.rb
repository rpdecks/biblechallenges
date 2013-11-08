require 'spec_helper'

describe MembershipsController, "Routing" do
  
  it { { get: '/memberships/'}.should route_to(controller: "memberships", action: "index") }

end

describe MembershipsController, "Actions as a visitor" do
  context "on GET to #new" do
    it "should render the new membership template" do
      #actually based on the subdomain it should render that specific new form
      get :new 
      should render_template("memberships/new")
    end
  end
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

  context "on GET to #show" do

    it "should render the show template " do
      membership = FactoryGirl.create(:membership, user: current_user)
      get :show, id: membership
      should render_template("memberships/show")
    end

    it "assigns the identified membership" do
      membership = FactoryGirl.create(:membership, user: current_user)
      get :show, id: membership
      assigns(:membership).should_not be_nil
    end

  end

end
