require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before do
    mock_auth_hash
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
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

  describe "#google" do
    it "should successfully create a user" do
      expect {
        post :google, provider: :google
      }.to change{ User.count }.by(1)
    end

    it "should redirect first-time sign-ups to finish_signup url" do
      post :google, provider: :google
      expect(response).to redirect_to finish_signup_path
    end
  end
end
