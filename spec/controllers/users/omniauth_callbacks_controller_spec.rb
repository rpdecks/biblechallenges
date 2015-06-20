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

    it "should redirect first-time sign-ups to finish_signup url" do
      post :facebook, provider: :facebook
      expect(response).to redirect_to finish_signup_path
    end
  end
end
