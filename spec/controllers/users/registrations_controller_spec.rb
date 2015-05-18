require 'spec_helper'

describe Users::RegistrationsController do

  it "should complete the user after creating via controller" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(UserCompletion).to receive(:new)

    post :create, user: attributes_for(:user)

    expect(UserCompletion).to have_received(:new)
  end
end

