require 'spec_helper'

describe ChallengesController, "Routing" do

  let(:subdomainurl) { "http://woot.lvh.me" }
  it { {get: "#{subdomainurl}"}.should route_to(controller: "challenges", action: "show") }

end

describe ChallengesController, "Actions as a visitor" do

  before do
    @challengeowner = FactoryGirl.create(:user)
    @challenge = FactoryGirl.create(:challenge, subdomain: "woot", owner: @challengeowner)
  end
  let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }


end
