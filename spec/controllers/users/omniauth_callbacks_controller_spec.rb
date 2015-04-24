require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "#facebook" do
    it "should successfully create a user" do
      expect {
        post :facebook, provider: :facebook
      }.to change{ User.count }.by(1)
    end

    it "should redirect the user to the root url" do
      post :facebook, provider: :facebook
      response.should redirect_to root_url
    end
  end
end
