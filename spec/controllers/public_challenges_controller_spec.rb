require 'spec_helper'

describe PublicChallengesController, "Routing" do
  it { {get: "/"}.should route_to(controller: "public_challenges", action: "index") }
end

describe PublicChallengesController, "Actions" do

  context "on GET to #index as a visitor" do

    it "loads public challenges" do
      get :index
      assigns(:public_challenges).should_not be_nil
    end

  end

end
