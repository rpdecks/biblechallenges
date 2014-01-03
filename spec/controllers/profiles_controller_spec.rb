require 'spec_helper'

describe ProfilesController do

  describe "Routing" do
    it { expect({get: '/profile/edit'}).to route_to(controller: 'profiles', action: 'edit') }
    it { expect({put: '/profile'}).to route_to(controller: 'profiles', action: 'update') }
  end



end
