require 'spec_helper'

describe ChallengesController, "Routing" do

  let(:subdomainurl) { "http://woot.lvh.me" }
  it { {get: "#{subdomainurl}"}.should route_to(controller: "challenges", action: "show") }

end

describe ChallengesController, "Actions as a visitor" do

  # here I'm getting a strange error about Email already taken, which
  # disappears if I run rake db:test:prepare  what gives pdb
  @challengeowner = FactoryGirl.create(:user)
  @challenge = FactoryGirl.create(:challenge, subdomain: "woot", owner: @challengeowner)
  let(:subdomainurl) { "http://#{@challenge.subdomain}.lvh.me" }


end
