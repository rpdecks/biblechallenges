require 'spec_helper'

describe ChallengesController, "Routing" do
  it { expect({get: "/"}).to route_to(controller: "challenges", action: "index") }
end

describe ChallengesController, "Actions" do
  context "on GET to #index as a visitor" do
    it "loads public challenges" do
      get :index
      assigns(:public_challenges).should_not be_nil
    end
  end
end
